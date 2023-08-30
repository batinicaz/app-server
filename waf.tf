data "dns_a_record_set" "allowed_access_to_nitter" {
  host = var.nitter_allowed_ips_dns
}

locals {
  allowed_ips = join(" ", data.dns_a_record_set.allowed_access_to_nitter.addrs)
}

resource "cloudflare_ruleset" "zone_level_waf" {
  zone_id     = data.cloudflare_zone.selected.zone_id
  name        = "WAF for ${data.cloudflare_zone.selected.name}"
  description = "Rules for acess to FreshRSS services"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules {
    action      = "block"
    description = "Restrict external access to Nitter to protect use of guest_tokens"
    expression  = "(http.host eq \"${local.services["nitter"].fqdn}\" and not ip.src in {${local.allowed_ips}})"
    enabled     = true
  }
}