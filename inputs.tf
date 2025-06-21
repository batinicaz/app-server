variable "availability_domain" {
  type        = string
  description = "Availability domain where instance will be launched."
}

variable "cloudflare_custom_list" {
  type        = string
  description = "The name of the custom list in CloudFlare containing trusted IP ranges"
}

variable "instance_ocpus" {
  type        = number
  description = "The number of Oracle CPU's to allocate to the instance"
  default     = 1
}

variable "instance_ram" {
  type        = number
  description = "The total amount of RAM (in gigabytes) to allocate to the instance"
  default     = 6
}

variable "instance_shape" {
  type        = string
  default     = "VM.Standard.A1.Flex"
  description = "Instance type to use, default is the always free domain ARM option."
}

variable "lb_bandwidth" {
  description = "Bandwidth in Mbps. Default is the always free option."
  type        = number
  default     = 10
}

variable "oci_fingerprint" {
  description = "The fingerprint of the key used to authenticate with OCI"
  type        = string
}

variable "oci_private_key" {
  description = "The private key to authenticate with OCI"
  sensitive   = true
  type        = string
}

variable "oci_region" {
  description = "The region in which to create resources"
  type        = string
}

variable "oci_tenancy_id" {
  description = "The tenancy id where to resources are to be created"
  type        = string
}

variable "oci_user_id" {
  description = "The ID of user that terraform will use to create the resources"
  type        = string
}

variable "private_key_pem" {
  description = "The base64 encoded private key pem for the TLS certificate used on the load balancer"
  type        = string
  sensitive   = true
}

variable "services" {
  description = "The configuration of the different services running on the app server instance"
  type = map(object({
    port                = number                // The port the service is running on
    subdomain           = string                // The subdomain to expose the service on
    update_nginx_config = optional(bool, false) // If true will replace the servername in the nginx config directory
    waf_block           = optional(bool, false) // If true will prevent access from anything other than trusted IP's
  }))
}

variable "tf_cloud_organisation" {
  description = "The name of the TF cloud organisation"
  type        = string
}

variable "zone_id" {
  description = "The CloudFlare zone id to work under"
  type        = string
}

locals {
  default_tags = {
    "terraform.managed" = "terraform"
    "terraform.repo"    = "https://github.com/batinicaz/app-server"
  }

  services = {
    for service, config in var.services :
    service => merge(config, {
      fqdn = "${config.subdomain}.${data.cloudflare_zone.selected.name}"
    })
  }
}
