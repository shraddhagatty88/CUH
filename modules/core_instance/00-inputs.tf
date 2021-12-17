############################################################################
# Module Input Variables:
############################################################################

variable "tenancy_id" {}

variable "instance_count" {
  default = 1
}

variable "availability_domain" {
  default = 0
}

variable "compartment_id" {}

variable "shape" {}

variable "display_name" {
  default = ""
}

variable "fault_domain" {
  default = 0
}

variable "is_consistent_volume_naming_enabled" {
  default = true
}

variable "is_pv_encryption_in_transit_enabled" {
  default = false
}

variable "preserve_boot_volume" {
  default = "true"
}

variable "subnet_id" {}

variable "assign_public_ip" {
  default = false
}

variable "vnic_display_name" {
  default = ""
}

variable "vnic_hostname_label" {
  default = ""
}

variable "private_ip" {
  type    = list(string)
  default = []
}

variable "skip_source_dest_check" {
  default = false
}

variable "ssh_authorized_keys" {
  default = ""
}

variable "user_data" {
  default = ""
}

variable "source_id" {}

variable "source_type" {
  default = "image"
}

variable "boot_volume_size_in_gbs" {
  default = 50
}

variable "create_boot_backup_policy" {
  default = true
}

variable "boot_backup_policy" {
  default = "bronze"
}

variable "network_sec_groups" {
  type    = list(string)
  default = []
}

variable "defined_tags" {
    type = map(string)
    default = {}
}

variable "shape_mem" {
  default = null
}

variable "shape_ocpus" {
  default = null
}

############################################################################
