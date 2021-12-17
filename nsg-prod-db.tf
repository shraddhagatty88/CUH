###########################################################################
# NSG - Prod Database:
###########################################################################

resource "oci_core_network_security_group" "nsg_prod_db" {
    compartment_id = module.iam.compartments["common_services"]
    vcn_id         = module.vcn.vcns["vcn1"]
    display_name   = "nsg_prod_db"
    defined_tags   = local.tags
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }
}
 
output "nsg_prod_db_id" {
    value = oci_core_network_security_group.nsg_prod_db.id
}

###########################################################################
# INGRESS:
###########################################################################

module "nsg_prod_db_ingress_sql_prod_db" {
    source                   = "./modules/network-sec-rules"
    net_sec_group_id         = oci_core_network_security_group.nsg_prod_db.id
    net_sec_rule_desc        = "nsg_prod_db_ingress_sql_prod_db"
    net_sec_rule_source      = oci_core_network_security_group.nsg_prod_app.id
    net_sec_rule_source_type = "NETWORK_SECURITY_GROUP"
    create_ingress_tcp       = true
    net_sec_rule_tcp_min     = "1521"
    net_sec_rule_tcp_max     = "1526"
}

module "nsg_prod_db_ingress_sql_prod_db2" {
    source                   = "./modules/network-sec-rules"
    net_sec_group_id         = oci_core_network_security_group.nsg_prod_db.id
    net_sec_rule_desc        = "nsg_prod_db_ingress_sql_prod_db2"
    net_sec_rule_source      = oci_core_network_security_group.nsg_prod_db.id
    net_sec_rule_source_type = "NETWORK_SECURITY_GROUP"
    create_ingress_tcp       = true
    net_sec_rule_tcp_min     = "1521"
    net_sec_rule_tcp_max     = "1526"
}

module "nsg_prod_db_ingress_sql_prod_db_from_access" {
    source                   = "./modules/network-sec-rules"
    net_sec_group_id         = oci_core_network_security_group.nsg_prod_db.id
    net_sec_rule_desc        = "nsg_prod_db_ingress_sql_prod_db_from_access"
    net_sec_rule_source      = oci_core_network_security_group.nsg_access.id
    net_sec_rule_source_type = "NETWORK_SECURITY_GROUP"
    create_ingress_tcp       = true
    net_sec_rule_tcp_min     = "1521"
    net_sec_rule_tcp_max     = "1526"
}

###########################################################################
# EGRESS:
###########################################################################


###########################################################################
