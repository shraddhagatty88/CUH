#Bastion
locals {
    bastion_max_session_ttl_in_seconds = 3 * 60 * 60 // 3 hrs.
}

resource "oci_bastion_bastion" "test_bastion" {
    #Required
    bastion_type = "STANDARD"
    compartment_id =  module.iam.compartments["common_services"]
    target_subnet_id = module.vcn.subnets["vcn1_sub_dmz"]
    name = "${var.customer_label}bastion"
    defined_tags = local.tags
    client_cidr_block_allow_list = var.public_src_bastion_cidrs
    max_session_ttl_in_seconds = local.bastion_max_session_ttl_in_seconds

    
}