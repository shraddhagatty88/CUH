############################################################################
# OCI - Core Module - VCN - Variables:
############################################################################

variable "vcn_inputs" {}
variable "dhcp_options" {
    default = null
}

locals {
    vcn_defaults = {
        vcn_defined_tags           = {}
        vcn_freeform_tags          = {}
        igw_enabled                = true
        nat_block_traffic          = false
        nat_public_ip_id           = null
        sgw_route_table_id         = null
        drg_route_table_id         = null
        lpg_peer_id                = null
        lpg_route_table_id         = null
        rpg_peer_id                = null
        rpg_peer_region_name       = null
        subnet_availability_domain = null
        # subnet_dhcp_options_id     = null
        subnet_ipv6cidr_block      = null
        subnet_route_table         = null
        subnet_security_list_ids   = null
    }
    vcn_params = flatten([
        for input_key, input in var.vcn_inputs : {
            input_key            = input_key
            vcn_dns_label        = input.vcn_dns_label
            vcn_cidr_block       = input.vcn_cidr_block
            vcn_compartment_id   = input.vcn_compartment_id

            vcn_defined_tags     = lookup(input, "vcn_defined_tags", local.vcn_defaults.vcn_defined_tags)
            vcn_freeform_tags    = lookup(input, "vcn_freeform_tags", local.vcn_defaults.vcn_freeform_tags)
            igw_enabled          = lookup(input, "igw_enabled", local.vcn_defaults.igw_enabled)
            nat_block_traffic    = lookup(input, "nat_block_traffic", local.vcn_defaults.nat_block_traffic)
            nat_public_ip_id     = lookup(input, "nat_public_ip_id", local.vcn_defaults.nat_public_ip_id)
            sgw_route_table_id   = lookup(input, "sgw_route_table_id", local.vcn_defaults.sgw_route_table_id)
            drg_route_table_id   = lookup(input, "drg_route_table_id", local.vcn_defaults.drg_route_table_id)
            lpg_peer_id          = lookup(input, "lpg_peer_id", local.vcn_defaults.lpg_peer_id)
            lpg_route_table_id   = lookup(input, "lpg_route_table_id", local.vcn_defaults.lpg_route_table_id)
            rpg_peer_id          = lookup(input, "rpg_peer_id", local.vcn_defaults.rpg_peer_id)
            rpg_peer_region_name = lookup(input, "rpg_peer_region_name", local.vcn_defaults.rpg_peer_region_name)
        }
    ])
    subnet_params = flatten([
        for input_key, input in var.vcn_inputs : [
            for subnet_key, subnet in input.subnets : {
                input_key                  = input_key
                subnet_key                 = subnet_key
                subnet_cidr_block          = subnet.subnet_cidr_block
                subnet_dns_label           = subnet.subnet_dns_label
                subnet_is_private          = subnet.subnet_is_private

                subnet_availability_domain = lookup(subnet, "subnet_availability_domain", local.vcn_defaults.subnet_availability_domain)
                subnet_dhcp_options_id     = lookup(subnet, "subnet_dhcp_options_id", var.dhcp_options)               
                subnet_ipv6cidr_block      = lookup(subnet, "subnet_ipv6cidr_block", local.vcn_defaults.subnet_ipv6cidr_block)
                subnet_route_table         = lookup(subnet, "subnet_route_table", local.vcn_defaults.subnet_route_table)
                subnet_security_list_ids   = lookup(subnet, "subnet_security_list_ids", local.vcn_defaults.subnet_security_list_ids)
            }
        ]
    ])
    route_table_params = flatten([
        for input_key, input in var.vcn_inputs : [
            for route_table_key, route_table in input.route_tables : {
                input_key       = input_key
                route_table_key = route_table_key
                route_rules     = route_table.route_rules
            }
        ]
    ])
}

############################################################################
