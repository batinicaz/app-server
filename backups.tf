locals {
  backup_buckets = toset([
    "backups-freshrss",
    "backups-planka"
  ])
}

resource "oci_kms_key" "backups" {
  for_each            = local.backup_buckets
  compartment_id      = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  desired_state       = "ENABLED"
  display_name        = each.value
  management_endpoint = data.terraform_remote_state.oci_core.outputs.kms_vault_endpoint
  protection_mode     = "SOFTWARE" // Always free

  defined_tags = merge(local.default_tags, {
    "terraform.name" = each.value
  })

  key_shape {
    algorithm = "AES"
    length    = "32" // 32 bytes AKA 256 bit key
  }
}

resource "oci_objectstorage_bucket" "backups" {
  for_each              = local.backup_buckets
  access_type           = "NoPublicAccess"
  compartment_id        = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  kms_key_id            = oci_kms_key.backups[each.value].id
  name                  = each.value
  namespace             = data.oci_objectstorage_namespace.terraform.namespace
  object_events_enabled = true
  storage_tier          = "Standard"
  versioning            = "Enabled"

  defined_tags = merge(local.default_tags, {
    "terraform.name" = each.value
  })

  depends_on = [
    // Can not create bucket until object store has permission to use the key
    oci_identity_policy.backup_bucket_can_use_key
  ]
}

resource "oci_objectstorage_object_lifecycle_policy" "delete_old_backups" {
  for_each  = local.backup_buckets
  namespace = oci_objectstorage_bucket.backups[each.value].namespace
  bucket    = oci_objectstorage_bucket.backups[each.value].name

  rules {
    action      = "DELETE"
    is_enabled  = true
    name        = "delete-old-backups"
    target      = "objects"
    time_amount = 2
    time_unit   = "DAYS"
  }

  rules {
    action      = "DELETE"
    is_enabled  = true
    name        = "delete-old-versions-of-backups"
    target      = "previous-object-versions"
    time_amount = 1
    time_unit   = "DAYS"
  }

  depends_on = [
    // Can not add lifecycle rule without service having permission
    oci_identity_policy.delete_old_backups
  ]
}
