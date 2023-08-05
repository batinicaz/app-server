resource "tls_cert_request" "freshrss" {
  dns_names       = values(local.services)[*].fqdn
  private_key_pem = base64decode(data.hcp_vault_secrets_app.freshrss.secrets["private_key"])

  subject {
    common_name = "${var.services["freshrss"].subdomain}.${var.domain_name}"
  }
}

resource "cloudflare_origin_ca_certificate" "freshrss" {
  csr                  = tls_cert_request.freshrss.cert_request_pem
  hostnames            = values(local.services)[*].fqdn
  min_days_for_renewal = 90
  request_type         = "origin-ecc"
  requested_validity   = 365
}


// Have to use a load balancer cert until certificate service fixed to support importing certs: https://github.com/oracle/terraform-provider-oci/issues/1477
resource "oci_load_balancer_certificate" "freshrss" {
  certificate_name   = "freshrss-${cloudflare_origin_ca_certificate.freshrss.id}"
  load_balancer_id   = oci_load_balancer.freshrss.id
  ca_certificate     = data.cloudflare_origin_ca_root_certificate.ecc.cert_pem
  private_key        = base64decode(data.hcp_vault_secrets_app.freshrss.secrets["private_key"])
  public_certificate = cloudflare_origin_ca_certificate.freshrss.certificate

  lifecycle {
    // Avoid downtime when rotating cert
    create_before_destroy = true
  }
}
