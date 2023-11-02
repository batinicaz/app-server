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
  access_type           = "NoPublicAccess"
  compartment_id        = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  kms_key_id            = oci_kms_key.backups.id
  name                  = "backups-freshrss"
  namespace             = data.oci_objectstorage_namespace.terraform.namespace
  object_events_enabled = true
  storage_tier          = "Standard"
  versioning            = "Enabled"

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "backups-freshrss"
  })

  depends_on = [
    // Can not create bucket until object store has permission to use the key
    oci_identity_policy.backup_bucket_can_use_key
  ]
}

resource "oci_objectstorage_object_lifecycle_policy" "delete_old_backups" {
  namespace = oci_objectstorage_bucket.backups.namespace
  bucket    = oci_objectstorage_bucket.backups.name

  rules {
    action      = "DELETE"
    is_enabled  = true
    name        = "delete-old-backups"
    target      = "objects"
    time_amount = 7
    time_unit   = "DAYS"
  }

  rules {
    action      = "DELETE"
    is_enabled  = true
    name        = "delete-old-versions-of-backups"
    target      = "previous-object-versions"
    time_amount = 7
    time_unit   = "DAYS"
  }

  depends_on = [
    // Can not add lifecycle rule without service having permission
    oci_identity_policy.delete_old_backups
  ]
}