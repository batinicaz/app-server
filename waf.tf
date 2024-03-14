data "dns_a_record_set" "trusted_ips_record" {
  host = var.trusted_ips_dns
}

locals {
  allowed_ips = join(" ", data.dns_a_record_set.trusted_ips_record.addrs)
}

resource "cloudflare_ruleset" "zone_level_waf" {
  zone_id     = data.cloudflare_zone.selected.zone_id
  name        = "WAF for ${data.cloudflare_zone.selected.name}"
  description = "Rules for access to FreshRSS services"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  dynamic "rules" {
    for_each = {
      for service, config in local.services :
      service => config if config.waf_block
    }
    content {
      action      = "block"
      description = "Restrict external access to ${rules.key}"
      expression  = "(http.host eq \"${rules.value.fqdn}\" and not ip.src in {${local.allowed_ips}})"
      enabled     = true
    }
  }
}