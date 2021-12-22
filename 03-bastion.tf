resource "oci_bastion_bastion" "test_bastion" {
    #Required
    bastion_type = "STANDARD"
    compartment_id =  module.iam.compartments["common_services"]
    target_subnet_id = module.vcn.subnets["vcn1_sub_dmz"]
    name = "${var.customer_label}bastion"
    defined_tags = local.tags

    /*#Optional
    client_cidr_block_allow_list = var.bastion_client_cidr_block_allow_list
    
    freeform_tags = {"bar-key"= "value"}
    max_session_ttl_in_seconds = var.bastion_max_session_ttl_in_seconds
   */
}