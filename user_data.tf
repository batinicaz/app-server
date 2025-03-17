resource "null_resource" "regenerate_key" {
  // Can not reference instance directly as that would be a cyclic dependency so track properties that will trigger a new instance
  triggers = {
    availability_domain    = var.availability_domain
    freshrss_backup_bucket = oci_objectstorage_bucket.backups["backups-freshrss"].name
    planka_backup_bucket   = oci_objectstorage_bucket.backups["backups-planka"].name
    compartment_id         = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
    image_id               = data.oci_core_images.app_server_latest.images[0].id
    shape                  = var.instance_shape
    subnet_id              = data.terraform_remote_state.oci_core.outputs.core_vcn_subnets["public"]
    run_cmds               = base64sha256(join(";", local.nginx_restart_config))
    template_params = base64sha256(join(",", [
      for k, v in local.template_params :
      "${k}=${v}"
    ]))
  }
}

resource "tailscale_tailnet_key" "app_server" {
  ephemeral = true
  expiry    = 3600 // 1 hour
  // Meaningless ternary to link with null resource for key re-creation
  preauthorized = length(null_resource.regenerate_key.id) > 0 ? true : true
  reusable      = false
  tags          = ["tag:oci"]
}

data "cloudinit_config" "bootstrap" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      hostname = "oci-app-server"
      write_files = [
        {
          path : "/etc/cron.d/sync-freshrss-backups",
          content : "30 1 * * * root oci os object sync --namespace ${oci_objectstorage_bucket.backups["backups-freshrss"].namespace} --bucket-name '${oci_objectstorage_bucket.backups["backups-freshrss"].name}' --src-dir /backups --auth instance_principal --delete && curl -fsS -m 10 --retry 5 -o /dev/null 'https://hc-ping.com/9a711459-6adf-4f5c-bdee-1153f0804477'\n",
          permissions : "0644",
          owner : "root:root"
        },
        {
          path : "/etc/cron.d/sync-planka-backups",
          content : "30 1 * * * root oci os object sync --namespace ${oci_objectstorage_bucket.backups["backups-planka"].namespace} --bucket-name '${oci_objectstorage_bucket.backups["backups-planka"].name}' --src-dir /opt/planka/backups --auth instance_principal --delete && curl -fsS -m 10 --retry 5 -o /dev/null 'https://hc-ping.com/14c533b1-f496-48e8-be2a-17768199492a'\n",
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
        "tailscale up --authkey ${tailscale_tailnet_key.app_server.key} --ssh",
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
      "sed -i 's#server_name ${service};#server_name ${config.fqdn};#' /etc/openresty/conf.d/${service}.conf" if config.update_nginx_config
    ],
    [
      "systemctl restart openresty",
    ]
  )
  template_params = {
    freshrss_bucket_namespace = oci_objectstorage_bucket.backups["backups-freshrss"].namespace
    freshrss_bucket_name      = oci_objectstorage_bucket.backups["backups-freshrss"].name
    freshrss_base_url         = local.services["freshrss"].fqdn
    freshrss_subdomain        = local.services["freshrss"].subdomain
    nitter_fqdn               = local.services["nitter"].fqdn
    planka_bucket_namespace   = oci_objectstorage_bucket.backups["backups-planka"].namespace
    planka_bucket_name        = oci_objectstorage_bucket.backups["backups-planka"].name
  }
}
