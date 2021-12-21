resource "oci_bastion_bastion" "test_bastion" {
    #Required
    bastion_type = standard
    compartment_id = var.compartment_id
    target_subnet_id = oci_core_subnet.test_subnet.id

    #Optional
    client_cidr_block_allow_list = var.bastion_client_cidr_block_allow_list
    defined_tags = {"foo-namespace.bar-key"= "value"}
    freeform_tags = {"bar-key"= "value"}
    max_session_ttl_in_seconds = var.bastion_max_session_ttl_in_seconds
    name = var.bastion_name
}