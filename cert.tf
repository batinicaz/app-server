resource "tls_cert_request" "app_server" {
  dns_names       = values(local.services)[*].fqdn
  private_key_pem = base64decode(var.private_key_pem)

  subject {
    common_name = "${var.services["freshrss"].subdomain}.${data.cloudflare_zone.selected.name}"
  }
}

resource "cloudflare_origin_ca_certificate" "app_server" {
  csr                = tls_cert_request.app_server.cert_request_pem
  hostnames          = sort(values(local.services)[*].fqdn)
  request_type       = "origin-ecc"
  requested_validity = 365
}

// Have to use a load balancer cert until certificate service fixed to support importing certs: https://github.com/oracle/terraform-provider-oci/issues/1477
resource "oci_load_balancer_certificate" "app_server" {
  certificate_name   = "app-server-${cloudflare_origin_ca_certificate.app_server.id}"
  load_balancer_id   = oci_load_balancer.app_server.id
  private_key        = base64decode(var.private_key_pem)
  public_certificate = cloudflare_origin_ca_certificate.app_server.certificate

  lifecycle {
    // Avoid downtime when rotating cert
    create_before_destroy = true
  }
}
