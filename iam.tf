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
  compartment_id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  name           = "FreshRSS-Backups"
  description    = "Allow access to FreshRSS backup bucket"
  statements = [
    <<-POLICY
      Allow dynamic-group ${oci_identity_dynamic_group.freshrss.name} to manage object-family in compartment id
      ${data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id}
      where target.bucket.name='${oci_objectstorage_bucket.backups.name}'
    POLICY
    ,
    <<-POLICY
      Allow dynamic-group ${oci_identity_dynamic_group.freshrss.name} to use keys in compartment id
      ${data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id}
      where target.key.id='${oci_kms_key.backups.id}'
    POLICY
  ]

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "FreshRSS-Backups"
  })
}

resource "oci_identity_policy" "backup_bucket_can_use_key" {
  compartment_id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  description    = "Allow the object storage service to use the freshrss-backup key"
  name           = "ObjectStorage-Use-FreshRSS-Backups-Key"

  statements = [
    <<-POLICY
      Allow service objectstorage-${var.oci_region}
      to use keys in compartment ${data.oci_identity_compartment.terraform.name}
      where target.key.id='${oci_kms_key.backups.id}'
    POLICY
  ]

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "ObjectStorage-Use-FreshRSS-Backups-Key"
  })
}