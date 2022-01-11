############################################################################
# Module Input Variables:
############################################################################

variable "tenancy_id" {
}

variable "backup_policy" {
  default = "bronze"
}

variable "vol_count" {
  default = 1
}

variable "availability_domain" {
}

variable "compartment_id" {
}

variable "volume_display_name" {
  default = ""
}

variable "size_in_gbs" {
  default = 50
}

variable "defined_tags" {
    type = map(string)
}

variable "source_details"{
  default = null
}

variable "source_id"{
  default = ""
  # OCID of BV (same AD) or BV Backup
}

 variable "source_type"{
  default = ""
  # "volume" or "volumeBackup"
}

############################################################################
