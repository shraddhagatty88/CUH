############################################################################
# NSG - Access:
############################################################################
# NSG:

resource "oci_core_network_security_group" "nsg_access" {
    compartment_id = module.iam.compartments["finance_common_services"]
    vcn_id         = module.vcn.vcns["vcn1"]
    display_name   = "nsg_access"
    #defined_tags   = local.tags
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }
}
 
output "nsg_access_id" {
    value = oci_core_network_security_group.nsg_access.id
}

############################################################################
# Ingress:

resource "oci_core_network_security_group_security_rule" "nsg_access_ingress_ssh_v1" {
    for_each                  = toset(var.access)
    network_security_group_id = oci_core_network_security_group.nsg_access.id
    direction                 = "INGRESS"
    protocol                  = "6"
    description               = each.key
    source                    = each.key
    source_type               = "CIDR_BLOCK"
    stateless                 = false
    tcp_options {
        destination_port_range {
            min = "22"
            max = "22"
        }
    }
} 

resource "oci_core_network_security_group_security_rule" "nsg_access_ingress_rdp_v1" {
    for_each                  =  toset(var.access)
    network_security_group_id = oci_core_network_security_group.nsg_access.id
    direction                 = "INGRESS"
    protocol                  = "6"
    description               = each.key
    source                    = each.key
    source_type               = "CIDR_BLOCK"
    stateless                 = false
    tcp_options {
        destination_port_range {
            min = "3389"
            max = "3389"
        }
    }
}

module "nsg_access_ingress_ssh" {
    source                   = "./modules/network-sec-rules"
    net_sec_group_id         = oci_core_network_security_group.nsg_access.id
    net_sec_rule_desc        = "nsg_access_ingress_ssh"
    net_sec_rule_source      = oci_core_network_security_group.nsg_access.id
    net_sec_rule_source_type = "NETWORK_SECURITY_GROUP"
    create_ingress_tcp       = true
    net_sec_rule_tcp_min     = "22"
    net_sec_rule_tcp_max     = "22"
}

module "nsg_access_ingress_rdp" {
    source                   = "./modules/network-sec-rules"
    net_sec_group_id         = oci_core_network_security_group.nsg_access.id
    net_sec_rule_desc        = "nsg_access_ingress_rdp"
    net_sec_rule_source      = oci_core_network_security_group.nsg_access.id
    net_sec_rule_source_type = "NETWORK_SECURITY_GROUP"
    create_ingress_tcp       = true
    net_sec_rule_tcp_min     = "3389"
    net_sec_rule_tcp_max     = "3389"
}

module "nsg_access_ingress_http" {
    source                   = "./modules/network-sec-rules"
    net_sec_group_id         = oci_core_network_security_group.nsg_access.id
    net_sec_rule_desc        = "nsg_access_ingress_http"
    net_sec_rule_source      = oci_core_network_security_group.nsg_access.id
    net_sec_rule_source_type = "NETWORK_SECURITY_GROUP"
    create_ingress_tcp       = true
    net_sec_rule_tcp_min     = "80"
    net_sec_rule_tcp_max     = "80"
}

module "nsg_access_ingress_https" {
    source                   = "./modules/network-sec-rules"
    net_sec_group_id         = oci_core_network_security_group.nsg_access.id
    net_sec_rule_desc        = "nsg_access_ingress_https"
    net_sec_rule_source      = oci_core_network_security_group.nsg_access.id
    net_sec_rule_source_type = "NETWORK_SECURITY_GROUP"
    create_ingress_tcp       = true
    net_sec_rule_tcp_min     = "443"
    net_sec_rule_tcp_max     = "443"
}
############################################################################
# Egress:

module "nsg_access_egress_out" {
    source                 = "./modules/network-sec-rules"
    net_sec_group_id       = oci_core_network_security_group.nsg_access.id
    net_sec_rule_desc      = "nsg_access_egress_out"
    net_sec_rule_dest      = "0.0.0.0/0"
    net_sec_rule_dest_type = "CIDR_BLOCK"
    create_egress_all      = true
}

############################################################################
