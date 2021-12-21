############################################################################
# Outputs:
############################################################################

output "common_services_compartment_id" {
  value = module.iam.compartments["common_services"]
}

output "prod_services_compartment_id" {
  value = module.iam.compartments["prod_services"]
}


############################################################################

output "sub_dmz_id" {
  value = module.vcn.subnets["vcn1_sub_dmz"]
}

output "sub_app_id" {
  value = module.vcn.subnets["vcn1_sub_private"]
}
################################################################################
