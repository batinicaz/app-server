resource "null_resource" "regenerate_key" {
  // Can not reference instance directly as that would be a cyclic dependency so track properties that will trigger a new instance
  triggers = {
    availability_domain = var.availability_domain
    backup_bucket       = oci_objectstorage_bucket.backups.bucket_id
    compartment_id      = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
    image_id            = data.hcp_packer_image.freshrss_latest.cloud_image_id
    shape               = var.instance_shape
    subnet_id           = data.terraform_remote_state.oci_core.outputs.core_vcn_subnets["public"]
  }
}

resource "tailscale_tailnet_key" "freshrss" {
  ephemeral     = true
  expiry        = 3600 // 1 hour
  preauthorized = true
  reusable      = false
  tags          = ["tag:OCI"]

  depends_on = [
    // Want to use a one time use key so need to generate a new key if the instance is to be rebuilt
    null_resource.regenerate_key
  ]
}

data "cloudinit_config" "bootstrap" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      hostname = "freshrss"
      write_files = [
        {
          path : "/etc/cron.d/sync-backups",
          content : "30 1 * * * root oci os object bulk-upload --namespace ${oci_objectstorage_bucket.backups.namespace} --bucket-name ${oci_objectstorage_bucket.backups.name} --download-dir /backups --auth instance_principal && curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/9a711459-6adf-4f5c-bdee-1153f0804477 \n",
          permissions : "0644",
          owner : "root:root"
        }
      ],
      runcmd = [
        "tailscale up --authkey ${tailscale_tailnet_key.freshrss.key} --ssh",
        "oci os object bulk-download --namespace ${oci_objectstorage_bucket.backups.namespace} --bucket-name ${oci_objectstorage_bucket.backups.name} --download-dir /backups --auth instance_principal",
        "systemctl restart cron",
        "freshrss_restore --latest",
        "sudo sed -i 's#\\(hostname = \\).*#\\1\"${local.services["nitter"].fqdn}\"#' /opt/nitter/nitter.conf",
        "systemctl restart nitter",
      ]
    })
  }
}
