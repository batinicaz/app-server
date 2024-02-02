resource "null_resource" "regenerate_key" {
  // Can not reference instance directly as that would be a cyclic dependency so track properties that will trigger a new instance
  triggers = {
    availability_domain = var.availability_domain
    backup_bucket       = oci_objectstorage_bucket.backups.bucket_id
    compartment_id      = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
    image_id            = data.hcp_packer_artifact.freshrss_latest.external_identifier
    shape               = var.instance_shape
    subnet_id           = data.terraform_remote_state.oci_core.outputs.core_vcn_subnets["public"]
    run_cmds            = base64sha256(join(";", local.nginx_restart_config))
    template_params = base64sha256(join(",", [
      for k, v in local.template_params :
      "${k}=${v}"
    ]))
  }
}

resource "tailscale_tailnet_key" "freshrss" {
  ephemeral = true
  expiry    = 3600 // 1 hour
  // Meaningless ternary to link with null resource for key re-creation
  preauthorized = length(null_resource.regenerate_key.id) > 0 ? true : true
  reusable      = false
  tags          = ["tag:OCI"]
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
          content : "30 1 * * * root oci os object bulk-upload --namespace ${oci_objectstorage_bucket.backups.namespace} --bucket-name '${oci_objectstorage_bucket.backups.name}' --src-dir /backups --auth instance_principal --no-overwrite && curl -fsS -m 10 --retry 5 -o /dev/null 'https://hc-ping.com/9a711459-6adf-4f5c-bdee-1153f0804477'\n",
          permissions : "0644",
          owner : "root:root"
        },
        {
          path : "/tmp/bootstrap.sh",
          content : base64encode(templatefile("${path.module}/templates/bootstrap.sh.tmpl", local.template_params))
          permissions : "0711",
          owner : "root:root"
          encoding : "b64"
        }
      ],
      runcmd = concat([
        "tailscale up --authkey ${tailscale_tailnet_key.freshrss.key} --ssh",
        "systemctl restart cron",
        "/tmp/bootstrap.sh"
      ], local.nginx_restart_config)
    })
  }
}

locals {
  nginx_restart_config = concat(
    [
      for service, config in local.services :
      "sed -i 's#server_name ${service};#server_name ${config.fqdn};#' /etc/nginx/conf.d/${service}.conf" if config.update_nginx_config
    ],
    [
      "systemctl restart nginx",
    ]
  )
  template_params = {
    bucket_namespace   = oci_objectstorage_bucket.backups.namespace
    bucket_name        = oci_objectstorage_bucket.backups.name
    freshrss_base_url  = local.services["freshrss"].fqdn
    freshrss_subdomain = local.services["freshrss"].subdomain
    nitter_fqdn        = local.services["nitter"].fqdn
  }
}
