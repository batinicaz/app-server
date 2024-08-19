resource "cloudflare_record" "services" {
  for_each = local.services
  zone_id  = data.cloudflare_zone.selected.id
  name     = each.value.subdomain
  proxied  = true
  ttl      = 1
  type     = "A"
  content  = oci_load_balancer.freshrss.ip_address_details[0].ip_address
}

resource "oci_core_network_security_group" "freshrss_lb" {
  compartment_id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  display_name   = "freshrss-lb"
  vcn_id         = data.terraform_remote_state.oci_core.outputs.core_vcn_id

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "freshrss-lb"
  })
}

resource "oci_core_network_security_group_security_rule" "lb_ingress" {
  for_each                  = toset(data.cloudflare_ip_ranges.current.ipv4_cidr_blocks)
  description               = "Ingress from CloudFlare"
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.freshrss_lb.id
  protocol                  = "6" // TCP
  source                    = each.value
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "lb_egress" {
  for_each                  = local.services
  description               = "Egress to freshrss instance"
  destination               = oci_core_network_security_group.freshrss_instance.id
  destination_type          = "NETWORK_SECURITY_GROUP"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.freshrss_lb.id
  protocol                  = "6" // TCP
  stateless                 = false

  tcp_options {
    destination_port_range {
      max = each.value.port
      min = each.value.port
    }
  }
}

resource "oci_load_balancer" "freshrss" {
  compartment_id             = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  display_name               = "freshrss"
  ip_mode                    = "IPV4"
  is_private                 = false
  network_security_group_ids = [oci_core_network_security_group.freshrss_lb.id]
  shape                      = "flexible"
  subnet_ids                 = [data.terraform_remote_state.oci_core.outputs.core_vcn_subnets["public"]]

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "freshrss"
  })

  shape_details {
    maximum_bandwidth_in_mbps = var.lb_bandwidth
    minimum_bandwidth_in_mbps = var.lb_bandwidth
  }
}

resource "oci_load_balancer_backend_set" "services" {
  for_each         = local.services
  load_balancer_id = oci_load_balancer.freshrss.id
  name             = each.key
  policy           = "LEAST_CONNECTIONS"

  health_checker {
    interval_ms       = 10000 // 10 seconds
    protocol          = "TCP"
    port              = each.value.port
    retries           = 5
    timeout_in_millis = 5000 // 5 seconds
  }
}

resource "oci_load_balancer_backend" "services" {
  for_each         = local.services
  backendset_name  = oci_load_balancer_backend_set.services[each.key].name
  ip_address       = oci_core_instance.freshrss.private_ip
  load_balancer_id = oci_load_balancer.freshrss.id
  port             = each.value.port
}

resource "oci_load_balancer_listener" "services" {
  default_backend_set_name = oci_load_balancer_backend_set.services["freshrss"].name
  load_balancer_id         = oci_load_balancer.freshrss.id
  name                     = "freshrss-tls"
  port                     = 443
  routing_policy_name      = oci_load_balancer_load_balancer_routing_policy.by_host.name
  protocol                 = "HTTP"

  ssl_configuration {
    certificate_name        = oci_load_balancer_certificate.freshrss.certificate_name
    cipher_suite_name       = "oci-modern-ssl-cipher-suite-v1"
    protocols               = ["TLSv1.2"] // TODO: Update when OCI supports 1.3
    verify_peer_certificate = false
  }
}

resource "oci_load_balancer_load_balancer_routing_policy" "by_host" {
  condition_language_version = "V1"
  load_balancer_id           = oci_load_balancer.freshrss.id
  name                       = "freshrss_by_host"

  dynamic "rules" {
    for_each = local.services
    iterator = service
    content {
      name      = service.key
      condition = "all(http.request.headers[(i 'host')] eq (i '${service.value.fqdn}'))"
      actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = oci_load_balancer_backend_set.services[service.key].name
      }
    }
  }
}