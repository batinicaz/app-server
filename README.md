# Fresh RSS

Configuration for my self-hosted Fresh RSS instance in Oracle Cloud.

Built on the image created in [freshrss-oci](https://github.com/batinicaz/freshrss-oci).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | ~> 2.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | ~> 0.68 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 5.0 |
| <a name="requirement_tailscale"></a> [tailscale](#requirement\_tailscale) | ~> 0.13 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 4.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | ~> 2.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | ~> 0.68 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.0 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 5.0 |
| <a name="provider_tailscale"></a> [tailscale](#provider\_tailscale) | ~> 0.13 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_origin_ca_certificate.freshrss](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/origin_ca_certificate) | resource |
| [cloudflare_record.services](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [null_resource.regenerate_key](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [oci_core_instance.freshrss](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_network_security_group.freshrss_instance](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group.freshrss_lb](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.freshrss_instance_egress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.freshrss_instance_ingress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.lb_egress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.lb_ingress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_identity_dynamic_group.freshrss](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group) | resource |
| [oci_identity_policy.access_backup_bucket](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_policy.backup_bucket_can_use_key](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_kms_key.backups](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_key) | resource |
| [oci_load_balancer.freshrss](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer) | resource |
| [oci_load_balancer_backend.services](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_backend) | resource |
| [oci_load_balancer_backend_set.services](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_backend_set) | resource |
| [oci_load_balancer_certificate.freshrss](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_certificate) | resource |
| [oci_load_balancer_listener.services](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_listener) | resource |
| [oci_load_balancer_load_balancer_routing_policy.by_host](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_load_balancer_routing_policy) | resource |
| [oci_objectstorage_bucket.backups](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket) | resource |
| [oci_objectstorage_object_lifecycle_policy.delete_old_backups](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object_lifecycle_policy) | resource |
| [tailscale_tailnet_key.freshrss](https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/resources/tailnet_key) | resource |
| [tls_cert_request.freshrss](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [cloudflare_ip_ranges.current](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/ip_ranges) | data source |
| [cloudflare_origin_ca_root_certificate.ecc](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/origin_ca_root_certificate) | data source |
| [cloudflare_zone.selected](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |
| [cloudinit_config.bootstrap](https://registry.terraform.io/providers/cloudinit/latest/docs/data-sources/config) | data source |
| [hcp_packer_image.freshrss_latest](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/packer_image) | data source |
| [hcp_vault_secrets_app.freshrss](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/vault_secrets_app) | data source |
| [oci_identity_compartment.terraform](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartment) | data source |
| [oci_objectstorage_namespace.terraform](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/objectstorage_namespace) | data source |
| [terraform_remote_state.oci_core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_domain"></a> [availability\_domain](#input\_availability\_domain) | Availability domain where instance will be launched. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The CloudFlare managed domain name to work under | `string` | n/a | yes |
| <a name="input_instance_shape"></a> [instance\_shape](#input\_instance\_shape) | Instance type to use, default is the always free domain x86 option. | `string` | `"VM.Standard.E2.1.Micro"` | no |
| <a name="input_lb_bandwidth"></a> [lb\_bandwidth](#input\_lb\_bandwidth) | Bandwidth in Mbps. Default is the always free option. | `number` | `10` | no |
| <a name="input_oci_fingerprint"></a> [oci\_fingerprint](#input\_oci\_fingerprint) | The fingerprint of the key used to authenticate with OCI | `string` | n/a | yes |
| <a name="input_oci_private_key"></a> [oci\_private\_key](#input\_oci\_private\_key) | The private key to authenticate with OCI | `string` | n/a | yes |
| <a name="input_oci_region"></a> [oci\_region](#input\_oci\_region) | The region in which to create resources | `string` | n/a | yes |
| <a name="input_oci_tenancy_id"></a> [oci\_tenancy\_id](#input\_oci\_tenancy\_id) | The tenancy id where to resources are to be created | `string` | n/a | yes |
| <a name="input_oci_user_id"></a> [oci\_user\_id](#input\_oci\_user\_id) | The ID of user that terraform will use to create the resources | `string` | n/a | yes |
| <a name="input_services"></a> [services](#input\_services) | The configuration of the different services running on the freshrss instance | <pre>map(object({<br>    subdomain = string // The subdomain to expose the service on<br>    port      = number // The port the service is running on<br>  }))</pre> | n/a | yes |
| <a name="input_tf_cloud_organisation"></a> [tf\_cloud\_organisation](#input\_tf\_cloud\_organisation) | The name of the TF cloud organisation | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->