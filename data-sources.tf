############################################################################
# Data Sources:
############################################################################
# Tenancy:

# Tenancy ID:
data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

# Tenancy Availability Domains:
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_regions" "these" {}

############################################################################
# Object Storage:

# Object Storage Services:
data "oci_core_services" "core_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

# Object Storage Namespace:
data "oci_objectstorage_namespace" "tenancy_namespace" {
}

############################################################################

# Cloud Guard

data "oci_cloud_guard_cloud_guard_configuration" "this" {
  compartment_id = var.tenancy_ocid
}


# Images DataSource
data "oci_core_images" "OSImage_bastion" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "6.10"
  shape                    = "VM.Standard.E2.1"

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

data "oci_core_images" "OSImage_opsview" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"
  shape                    = "VM.Standard.E2.1"

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

