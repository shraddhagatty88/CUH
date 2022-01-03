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

