############################################################################
# OCI - Module - VPN - Main:
############################################################################

############################################################################
# CPE:
############################################################################

resource "oci_core_cpe" "cpe" {
    for_each = {
        for param in local.vpn_params : param.input_key => param
    }

    compartment_id      = each.value.compartment_id
    ip_address          = each.value.cpe_ip_address

    cpe_device_shape_id = each.value.cpe_device_shape_id
    defined_tags        = each.value.defined_tags
    display_name        = each.key
    freeform_tags       = each.value.freeform_tags

    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }
}

############################################################################
# IPSec Connection:
############################################################################

resource "oci_core_ipsec" "ip_sec_connection" {
    for_each = {
        for param in local.vpn_params : param.input_key => param
    }

    compartment_id            = each.value.compartment_id
    cpe_id                    = oci_core_cpe.cpe[each.key].id
    drg_id                    = each.value.ip_sec_drg_id
    static_routes             = each.value.ip_sec_static_routes

    cpe_local_identifier      = each.value.ip_sec_cpe_local_identifier
    cpe_local_identifier_type = each.value.ip_sec_cpe_local_identifier_type
    defined_tags              = each.value.defined_tags
    display_name              = each.key
    freeform_tags             = each.value.freeform_tags

    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
        ]
    }
}

############################################################################
# IPSec Tunnels:
############################################################################

#data "oci_core_ipsec_connection_tunnels" "ip_sec_connection_tunnels" {
#    ipsec_id = oci_core_ipsec.ip_sec_connection.id
#    filter {
#        name   = "name"
#        values = [data.oci_identity_tenancy.tenancy.home_region_key]
#    }
#}

# resource "oci_core_ipsec_connection_tunnel_management" "test_ip_sec_connection_tunnel" {
     #Required
#     ipsec_id  = oci_core_ipsec.ip_sec_connection.id
#     tunnel_id = oci_core_ipsec_connection_tunnels.ip_sec_connection_tunnels.id
#     routing   = "STATIC"
     #Optional
     #bgp_session_info {
         #Optional
     #    customer_bgp_asn = var.ip_sec_connection_tunnel_management_bgp_session_info_customer_bgp_asn
     #    customer_interface_ip = var.ip_sec_connection_tunnel_management_bgp_session_info_customer_interface_ip
     #    oracle_interface_ip = var.ip_sec_connection_tunnel_management_bgp_session_info_oracle_interface_ip
     #}
     #display_name = var.ip_sec_connection_tunnel_management_display_name
     #shared_secret = var.ip_sec_connection_tunnel_management_shared_secret
#     ike_version = "V2"
# }

#############################################################################
