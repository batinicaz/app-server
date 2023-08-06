resource "oci_core_instance" "freshrss" {
  availability_domain                 = var.availability_domain
  compartment_id                      = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  display_name                        = "freshrss-production"
  is_pv_encryption_in_transit_enabled = true
  shape                               = var.instance_shape

  create_vnic_details {
    assign_public_ip = false
    nsg_ids          = [oci_core_network_security_group.freshrss_instance.id]
    subnet_id        = data.terraform_remote_state.oci_core.outputs.core_vcn_subnets["private"]
  }

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "freshrss-production"
  })

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  launch_options {
    network_type                        = "PARAVIRTUALIZED"
    is_pv_encryption_in_transit_enabled = true
  }

  metadata = {
    user_data = data.cloudinit_config.bootstrap.rendered
  }

  source_details {
    source_id               = data.hcp_packer_image.freshrss_latest.cloud_image_id
    source_type             = "image"
    boot_volume_size_in_gbs = "50"
  }
}

resource "oci_core_network_security_group" "freshrss_instance" {
  compartment_id = data.terraform_remote_state.oci_core.outputs.terraform_identity_compartment_id
  display_name   = "Fresh RSS Server"
  vcn_id         = data.terraform_remote_state.oci_core.outputs.core_vcn_id

  defined_tags = merge(local.default_tags, {
    "terraform.name" = "freshrss-production"
  })
}

resource "oci_core_network_security_group_security_rule" "freshrss_instance_ingress" {
  for_each                  = local.services
  description               = "Allow ingress from LB"
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.freshrss_instance.id
  protocol                  = "6" // TCP
  source                    = oci_core_network_security_group.freshrss_lb.id
  source_type               = "NETWORK_SECURITY_GROUP"
  stateless                 = false

  tcp_options {
    destination_port_range {
      max = each.value.port
      min = each.value.port
    }
  }
}

resource "oci_core_network_security_group_security_rule" "freshrss_instance_egress" {
  // checkov:skip=CKV2_OCI_2: False positive should not be triggered on egress rule
  description               = "Allow all egress"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  protocol                  = "all"
  network_security_group_id = oci_core_network_security_group.freshrss_instance.id
  stateless                 = false
}
