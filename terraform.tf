terraform {
  required_version = "~> 1.5"
  required_providers {
    cloudinit = {
      source  = "cloudinit"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    dns = {
      source  = "hashicorp/dns"
      version = "~> 3.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.68"
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.13"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "oci" {
  fingerprint  = var.oci_fingerprint
  private_key  = var.oci_private_key
  region       = var.oci_region
  tenancy_ocid = var.oci_tenancy_id
  user_ocid    = var.oci_user_id


  ignore_defined_tags = [
    "Oracle-Tags.CreatedBy",
    "Oracle-Tags.CreatedOn",
  ]
}
