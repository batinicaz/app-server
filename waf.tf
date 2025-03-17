data "dns_a_record_set" "trusted_ips_record" {
  host = var.trusted_ips_dns
}

locals {
  allowed_ips = join(" ", data.dns_a_record_set.trusted_ips_record.addrs)
  services_behind_waf = {
    for service, config in local.services :
    service => config if config.waf_block
  }
}

resource "cloudflare_ruleset" "zone_level_waf" {
  zone_id     = data.cloudflare_zone.selected.zone_id
  name        = "WAF for ${data.cloudflare_zone.selected.name}"
  description = "Rules for access to OCI App Server services"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    for service, config in local.services_behind_waf :
    {
      action      = "block"
      description = "Restrict external access to ${service}"
      expression  = "(http.host eq \"${config.fqdn}\" and not ip.src in {${local.allowed_ips}})"
      enabled     = true
    }
  ]
}
