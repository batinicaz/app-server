resource "oci_identity_dynamic_group" "freshrss" {
  compartment_id = var.oci_tenancy_id
  name           = "FreshRSS"
  description    = "Contains the FreshRSS server only"
  matching_rule  = "instance.id = '${oci_core_instance.freshrss.id}'"

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "FreshRSS"
  })
}

resource "oci_identity_policy" "access_backup_bucket" {
  for_each       = local.backup_buckets
  compartment_id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  name           = each.value
  description    = "Allow access to ${each.value} bucket"
  statements = [
    <<-POLICY
      Allow dynamic-group ${oci_identity_dynamic_group.freshrss.name} to manage object-family in compartment id
      ${data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id}
      where target.bucket.name='${oci_objectstorage_bucket.backups[each.value].name}'
    POLICY
    ,
    <<-POLICY
      Allow dynamic-group ${oci_identity_dynamic_group.freshrss.name} to use keys in compartment id
      ${data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id}
      where target.key.id='${oci_kms_key.backups[each.value].id}'
    POLICY
  ]

  defined_tags = merge(local.default_tags, {
    "terraform.name" = each.value
  })
}

resource "oci_identity_policy" "backup_bucket_can_use_key" {
  for_each       = local.backup_buckets
  compartment_id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  description    = "Allow the object storage service to use the ${each.value} key"
  name           = "ObjectStorage-Use-${each.value}-Key"

  statements = [
    <<-POLICY
      Allow service objectstorage-${var.oci_region}
      to use keys in compartment ${data.oci_identity_compartment.terraform.name}
      where target.key.id='${oci_kms_key.backups[each.value].id}'
    POLICY
  ]

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "ObjectStorage-Use-${each.value}-Key"
  })
}

resource "oci_identity_policy" "delete_old_backups" {
  for_each       = local.backup_buckets
  compartment_id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  description    = "Allow the object storage service to delete old ${each.value}"
  name           = "ObjectStorage-Delete-${each.value}"

  statements = [
    <<-POLICY
      Allow service objectstorage-${var.oci_region}
      to manage object-family in compartment ${data.oci_identity_compartment.terraform.name}
      where target.bucket.name='${oci_objectstorage_bucket.backups[each.key].name}'
    POLICY
  ]

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "ObjectStorage-Delete-${each.value}"
  })
}