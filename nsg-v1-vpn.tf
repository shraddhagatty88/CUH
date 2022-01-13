############################################################################
# NSG - Prod Application:
############################################################################
# NSG:

resource "oci_core_network_security_group" "nsg_v1_vpn" {
    compartment_id = module.iam.compartments["common_services"]
    vcn_id         = module.vcn.vcns["gmp_vcn"]
    display_name   = "nsg_v1_vpn"
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
 
output "nsg_v1_vpn_id" {
    value = oci_core_network_security_group.nsg_v1_vpn.id
}

############################################################################
############################################################################
# INGRESS:

resource "oci_core_network_security_group_security_rule" "nsg_v1_vpn_ingress_ssh_v1_vpn" {
    for_each                  = toset(local.v1_domains)
    network_security_group_id = oci_core_network_security_group.nsg_v1_vpn.id
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

resource "oci_core_network_security_group_security_rule" "nsg_v1_vpn_ingress_https_v1_vpn" {
    for_each                  = toset(local.v1_domains)
    network_security_group_id = oci_core_network_security_group.nsg_v1_vpn.id
    direction                 = "INGRESS"
    protocol                  = "6"
    description               = each.key
    source                    = each.key
    source_type               = "CIDR_BLOCK"
    stateless                 = false
    tcp_options {
        destination_port_range {
            min = "443"
            max = "443"
        }
    }
} 

resource "oci_core_network_security_group_security_rule" "nsg_v1_vpn_ingress_rdp_v1_vpn" {
    for_each                  = toset(local.v1_domains)
    network_security_group_id = oci_core_network_security_group.nsg_v1_vpn.id
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

resource "oci_core_network_security_group_security_rule" "nsg_v1_vpn_ingress_vnc_v1_vpn" {
    for_each                  = toset(local.v1_domains)
    network_security_group_id = oci_core_network_security_group.nsg_v1_vpn.id
    direction                 = "INGRESS"
    protocol                  = "6"
    description               = each.key
    source                    = each.key
    source_type               = "CIDR_BLOCK"
    stateless                 = false
    tcp_options {
        destination_port_range {
            min = "5901"
            max = "5910"
        }
    }
} 

resource "oci_core_network_security_group_security_rule" "nsg_v1_vpn_ingress_http_app_v1_vpn" {
    for_each                  = toset(local.v1_domains)
    network_security_group_id = oci_core_network_security_group.nsg_v1_vpn.id
    direction                 = "INGRESS"
    protocol                  = "6"
    description               = each.key
    source                    = each.key
    source_type               = "CIDR_BLOCK"
    stateless                 = false
    tcp_options {
        destination_port_range {
            min = "8000"
            max = "8024"
        }
    }
} 

resource "oci_core_network_security_group_security_rule" "nsg_v1_vpn_ingress_sql_v1_vpn" {
    for_each                  = toset(local.v1_domains)
    network_security_group_id = oci_core_network_security_group.nsg_v1_vpn.id
    direction                 = "INGRESS"
    protocol                  = "6"
    description               = each.key
    source                    = each.key
    source_type               = "CIDR_BLOCK"
    stateless                 = false
    tcp_options {
        destination_port_range {
            min = "1521"
            max = "1545"
        }
    }
} 

resource "oci_core_network_security_group_security_rule" "nsg_v1_vpn_ingress_http_asserter_v1_vpn" {
    for_each                  = toset(local.v1_domains)
    network_security_group_id = oci_core_network_security_group.nsg_v1_vpn.id
    direction                 = "INGRESS"
    protocol                  = "6"
    description               = each.key
    source                    = each.key
    source_type               = "CIDR_BLOCK"
    stateless                 = false
    tcp_options {
        destination_port_range {
            min = "7000"
            max = "7010"
        }
    }
} 

############################################################################
############################################################################
# EGRESS:

resource "oci_core_network_security_group_security_rule" "nsg_v1_vpn_egress_all_v1_vpn" {
    for_each                  = toset(local.v1_domains)
    network_security_group_id = oci_core_network_security_group.nsg_v1_vpn.id
    direction                 = "EGRESS"
    protocol                  = "all"
    description               = each.key
    destination               = each.key
    destination_type          = "CIDR_BLOCK"
    stateless                 = false
} 

############################################################################
