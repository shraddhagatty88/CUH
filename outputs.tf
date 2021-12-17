############################################################################
# Outputs:
############################################################################
/*
output "common_services_compartment_id" {
  value = module.iam.compartments["common_services"]
}

output "prod_services_compartment_id" {
  value = module.iam.compartments["prod_services"]
}

output "nprd_services_compartment_id" {
  value = module.iam.compartments["nprd_services"]
}

############################################################################

output "sub_dmz_id" {
  value = module.vcn.subnets["gmp_vcn_sub_dmz"]
}

output "sub_app_id" {
  value = module.vcn.subnets["gmp_vcn_sub_app"]
}

output "sub_db_id" {
  value = module.vcn.subnets["gmp_vcn_sub_db"]
}

output "sub_lbint_id" {
  value = module.vcn.subnets["gmp_vcn_sub_lbint"]
}

output "sub_fss_id" {
  value = module.vcn.subnets["gmp_vcn_sub_fss"]
}

################################################################################

output "nprd_mount_target" {
  value = oci_file_storage_mount_target.GMP_nprd_mount_target.id
}
output "prod_mount_target" {
  value = oci_file_storage_mount_target.GMP_prod_mount_target.id
}
output "dr_mount_target" {
  value = oci_file_storage_mount_target.GMP_dr_mount_target.id
}
*/