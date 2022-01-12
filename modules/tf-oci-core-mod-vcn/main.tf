############################################################################
# OCI - Core Module - IAM - Main:
############################################################################

############################################################################
# VCN:
############################################################################

resource "oci_core_vcn" "vcn" {
    for_each = {
        for param in local.vcn_params : param.input_key => param
    }
    
    display_name   = each.key
    dns_label      = each.value.vcn_dns_label
    cidr_block     = each.value.vcn_cidr_block
    compartment_id = each.value.vcn_compartment_id

   # defined_tags   = each.value.vcn_defined_tags  
    freeform_tags  = each.value.vcn_freeform_tags 

   /* lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }*/
}

############################################################################
# VCN - Default DHCP Options:
############################################################################

resource "oci_core_default_dhcp_options" "default-dhcp-options" {
    for_each = {
        for param in local.vcn_params : param.input_key => param
    }

    manage_default_resource_id = oci_core_vcn.vcn[each.key].default_dhcp_options_id

    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
    options {
        type = "SearchDomain"
        search_domain_names = [ "${each.value.vcn_dns_label}.oraclevcn.com" ]
    }
}

############################################################################
# VCN - Default Route Table:
############################################################################

resource "oci_core_default_route_table" "route_table" {
    for_each = var.vcn_inputs

    manage_default_resource_id = oci_core_vcn.vcn[each.key].default_route_table_id
}

############################################################################
# VCN - Default Security List:
############################################################################

resource "oci_core_default_security_list" "security_list" {
    for_each = var.vcn_inputs

    manage_default_resource_id = oci_core_vcn.vcn[each.key].default_security_list_id
}

############################################################################
# VCN - Internet Gateway:
############################################################################

resource "oci_core_internet_gateway" "internet_gateway" {
    for_each = {
        for param in local.vcn_params : param.input_key => param
    }

    compartment_id = oci_core_vcn.vcn[each.key].compartment_id
    vcn_id         = oci_core_vcn.vcn[each.key].id
    enabled        = each.value.igw_enabled
    display_name   = "${oci_core_vcn.vcn[each.key].display_name}_igw"
    defined_tags   = oci_core_vcn.vcn[each.key].defined_tags
    freeform_tags  = oci_core_vcn.vcn[each.key].freeform_tags
/*
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }*/
}

############################################################################
# VCN - NAT Gateway:
############################################################################

resource "oci_core_nat_gateway" "nat_gateway" {
    for_each = {
        for param in local.vcn_params : param.input_key => param
    }

    compartment_id = oci_core_vcn.vcn[each.key].compartment_id
    vcn_id         = oci_core_vcn.vcn[each.key].id
    block_traffic  = each.value.nat_block_traffic
    #defined_tags   = oci_core_vcn.vcn[each.key].defined_tags
    display_name   = "${oci_core_vcn.vcn[each.key].display_name}_nat"
    freeform_tags  = oci_core_vcn.vcn[each.key].freeform_tags
    public_ip_id   = each.value.nat_public_ip_id
/*
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }*/
}

############################################################################
# VCN - Service Gateway:
############################################################################

data "oci_core_services" "core_services" {
    filter {
        name   = "name"
        values = ["All .* Services In Oracle Services Network"]
        regex  = true
    }
}

resource "oci_core_service_gateway" "service_gateway" {
    for_each = {
        for param in local.vcn_params : param.input_key => param
    }
    
    compartment_id = oci_core_vcn.vcn[each.key].compartment_id
    vcn_id         = oci_core_vcn.vcn[each.key].id
    services {
        service_id = data.oci_core_services.core_services.services[0]["id"]
    }
    #defined_tags   = oci_core_vcn.vcn[each.key].defined_tags
    display_name   = "${oci_core_vcn.vcn[each.key].display_name}_sgw"
    freeform_tags  = oci_core_vcn.vcn[each.key].freeform_tags
    route_table_id = each.value.sgw_route_table_id
/*
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }*/
}

############################################################################
# VCN - DRG:
############################################################################

resource "oci_core_drg" "drg" {
    for_each = {
        for param in local.vcn_params : param.input_key => param
    }

    compartment_id = oci_core_vcn.vcn[each.key].compartment_id
    #defined_tags   = oci_core_vcn.vcn[each.key].defined_tags
    display_name   = "${oci_core_vcn.vcn[each.key].display_name}_drg"
    freeform_tags  = oci_core_vcn.vcn[each.key].freeform_tags
/*
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }*/
}

resource "oci_core_drg_attachment" "drg_attachment" {
    for_each = {
        for param in local.vcn_params : param.input_key => param
    }
    drg_id         = oci_core_drg.drg[each.key].id
    vcn_id         = oci_core_vcn.vcn[each.key].id
    display_name   = "${oci_core_vcn.vcn[each.key].display_name}_drg_attachment"
    route_table_id = each.value.drg_route_table_id
}

############################################################################
# VCN - RPG:
############################################################################

resource "oci_core_remote_peering_connection" "remote_peering_connection" {
    for_each = {
        for param in local.vcn_params : param.input_key => param
    }
    compartment_id   = oci_core_vcn.vcn[each.key].compartment_id
    drg_id           = oci_core_drg.drg[each.key].id
    #defined_tags     = oci_core_vcn.vcn[each.key].defined_tags
    display_name     = "${oci_core_vcn.vcn[each.key].display_name}_rpg"
    freeform_tags    = oci_core_vcn.vcn[each.key].freeform_tags
    peer_id          = each.value.rpg_peer_id
    peer_region_name = each.value.rpg_peer_region_name
/*
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }*/
}

############################################################################
# VCN - LPG:
############################################################################

resource "oci_core_local_peering_gateway" "local_peering_gateway" {
    for_each = {
        for param in local.vcn_params : param.input_key => param
    }
    compartment_id = oci_core_vcn.vcn[each.key].compartment_id
    vcn_id         = oci_core_vcn.vcn[each.key].id
    #defined_tags   = oci_core_vcn.vcn[each.key].defined_tags
    display_name   = "${oci_core_vcn.vcn[each.key].display_name}_lpg"
    freeform_tags  = oci_core_vcn.vcn[each.key].freeform_tags
    peer_id        = each.value.lpg_peer_id
    route_table_id = each.value.lpg_route_table_id
/*
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }*/
}

############################################################################
# VCN - Subnet:
############################################################################

resource "oci_core_subnet" "subnet" {
    for_each = {
        for param in local.subnet_params : param.subnet_key => param
    }
    cidr_block                 = each.value.subnet_cidr_block
    compartment_id             = oci_core_vcn.vcn[each.value.input_key].compartment_id
    vcn_id                     = oci_core_vcn.vcn[each.value.input_key].id
    availability_domain        = each.value.subnet_availability_domain
    #defined_tags               = oci_core_vcn.vcn[each.value.input_key].defined_tags
    dhcp_options_id            = each.value.subnet_dhcp_options_id
    display_name               = "${oci_core_vcn.vcn[each.value.input_key].display_name}_sub_${each.value.subnet_key}"
    dns_label                  = each.value.subnet_dns_label
    freeform_tags              = oci_core_vcn.vcn[each.value.input_key].freeform_tags
    ipv6cidr_block             = each.value.subnet_ipv6cidr_block
    prohibit_public_ip_on_vnic = each.value.subnet_is_private
    route_table_id             = each.value.subnet_route_table != null ? oci_core_route_table.route_table[each.value.subnet_route_table].id : each.value.subnet_route_table
    security_list_ids          = each.value.subnet_security_list_ids
/*
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }*/
}

############################################################################
# VCN - Route Table:
############################################################################

resource "oci_core_route_table" "route_table" {
    for_each = {
        for param in local.route_table_params : param.route_table_key => param
    }
    compartment_id = oci_core_vcn.vcn[each.value.input_key].compartment_id
    vcn_id         = oci_core_vcn.vcn[each.value.input_key].id
    display_name   = "${oci_core_vcn.vcn[each.value.input_key].display_name}_rt_${each.value.route_table_key}"
   # defined_tags   = oci_core_vcn.vcn[each.value.input_key].defined_tags
    freeform_tags  = oci_core_vcn.vcn[each.value.input_key].freeform_tags
    
    dynamic "route_rules" {
        for_each = each.value.route_rules
        content {
            network_entity_id = route_rules.value.route_rule_network_entity_id == "IGW" ? oci_core_internet_gateway.internet_gateway[each.value.input_key].id : (route_rules.value.route_rule_network_entity_id == "NAT" ? oci_core_nat_gateway.nat_gateway[each.value.input_key].id : (route_rules.value.route_rule_network_entity_id == "DRG" ? oci_core_drg.drg[each.value.input_key].id : (route_rules.value.route_rule_network_entity_id == "SGW" ? oci_core_service_gateway.service_gateway[each.value.input_key].id : null)))
            description       = "${each.value.route_table_key}_rt_rule_${route_rules.value.route_rule_network_entity_id}"
            destination       = route_rules.value.route_rule_destination
            destination_type  = route_rules.value.route_rule_destination_type
        }
    }
/*
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }*/
}

############################################################################
