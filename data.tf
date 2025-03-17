data "cloudflare_ip_ranges" "current" {}

data "cloudflare_zone" "selected" {
  zone_id = var.zone_id
}

data "oci_core_images" "app_server_latest" {
  compartment_id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  sort_by        = "TIMECREATED"
  sort_order     = "DESC"

  filter {
    name   = "defined_tags.terraform.managed"
    values = ["packer"]
  }

  filter {
    name   = "defined_tags.terraform.repo"
    values = ["https://github.com/batinicaz/app-server-oci"]
  }

  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
}

data "hcp_vault_secrets_app" "app_server" {
  app_name = "app-server"
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
