resource "oci_kms_key" "backups" {
  compartment_id      = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  desired_state       = "ENABLED"
  display_name        = "freshrss-backups"
  management_endpoint = data.terraform_remote_state.oci_core.outputs.kms_vault_endpoint
  protection_mode     = "SOFTWARE" // Always free

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "freshrss-backups"
  })

  key_shape {
    algorithm = "AES"
    length    = "32" // 32 bytes AKA 256 bit key
  }
}

resource "oci_objectstorage_bucket" "backups" {
  // checkov:skip=CKV_OCI_8: Versioning intentionally disabled as not compatible with retention rules
  access_type           = "NoPublicAccess"
  compartment_id        = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  kms_key_id            = oci_kms_key.backups.id
  name                  = "freshrss-backups"
  namespace             = data.oci_objectstorage_namespace.terraform.namespace
  object_events_enabled = true
  storage_tier          = "Standard"

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "freshrss-backups"
  })

  retention_rules {
    display_name = "keep-backups-for-7-days"
    duration {
      time_amount = 7
      time_unit   = "DAYS"
    }
    time_rule_locked = "2023-09-01T00:00:00Z"
  }

  depends_on = [
    // Can not create bucket until object store has permission to use the key
    oci_identity_policy.backup_bucket_can_use_key
  ]
}