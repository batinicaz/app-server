data "cloudflare_ip_ranges" "current" {}

data "cloudflare_zone" "selected" {
  zone_id = var.zone_id
}

data "hcp_packer_artifact" "freshrss_latest" {
  bucket_name  = "oci-images-freshrss-stable"
  platform     = "packer.oracle.oci"
  channel_name = "latest"
  region       = var.oci_region
}

data "hcp_vault_secrets_app" "freshrss" {
  app_name = "freshrss"
}

data "oci_identity_compartment" "terraform" {
  id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
}

data "oci_objectstorage_namespace" "terraform" {
  compartment_id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
}

data "terraform_remote_state" "oci_core" {
  backend = "remote"
  config = {
    organization = var.tf_cloud_organisation
    workspaces = {
      name = "oci-core"
    }
  }
}
