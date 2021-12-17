############################################################################
# Module - OCI IAM - Outputs:
############################################################################

############################################################################
# Compartments:
############################################################################

output "compartment_ids" {
  value = [
    for compartment in oci_identity_compartment.compartment:
      compartment.id
  ]
}

output "compartment_names" {
  value = [
    for compartment in oci_identity_compartment.compartment:
      compartment.name
  ]
}

############################################################################
# Tag Namespaces:
############################################################################

output "tag_namespaces_ids" {
  value = [
    for tag_namespace in oci_identity_tag_namespace.tag_namespace:
      tag_namespace.id
  ]
}

############################################################################
