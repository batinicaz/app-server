variable "availability_domain" {
  type        = string
  description = "Availability domain where instance will be launched."
}

variable "domain_name" {
  description = "The CloudFlare managed domain name to work under"
  type        = string
}

variable "instance_shape" {
  type        = string
  default     = "VM.Standard.A1.Flex"
  description = "Instance type to use, default is the always free domain ARM option."
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

variable "lb_bandwidth" {
  description = "Bandwidth in Mbps. Default is the always free option."
  type        = number
  default     = 10
}

variable "services" {
  description = "The configuration of the different services running on the freshrss instance"
  type = map(object({
    subdomain = string // The subdomain to expose the service on
    port      = number // The port the service is running on
  }))
  validation {
    condition     = length(setintersection(["freshrss", "nitter"], toset(keys(var.services)))) == 2
    error_message = "The only services supported are freshrss and nitter"
  }
}

variable "tf_cloud_organisation" {
  description = "The name of the TF cloud organisation"
  type        = string
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

locals {
  default_tags = {
    "terraform.managed" = "terraform"
    "terraform.repo"    = "https://github.com/batinicaz/freshrss"
  }

  services = {
    for service, config in var.services :
    service => merge(config, {
      fqdn = "${config.subdomain}.${var.domain_name}"
    })
  }
}