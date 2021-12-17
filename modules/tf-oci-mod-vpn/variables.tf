############################################################################
# OCI - Module - VPN - Variables:
############################################################################

variable "vpn_inputs" {}

locals {
    vpn_defaults = {
        defined_tags                     = {}
        freeform_tags                    = {}
        cpe_device_shape_id              = null
        ip_sec_cpe_local_identifier      = null
        ip_sec_cpe_local_identifier_type = null
    }
    vpn_params = flatten([
        for input_key, input in var.vpn_inputs : {
            input_key            = input_key
            compartment_id       = input.compartment_id
            cpe_ip_address       = input.cpe_ip_address
            ip_sec_drg_id        = input.ip_sec_drg_id
            ip_sec_static_routes = input.ip_sec_static_routes

            defined_tags                     = lookup(input, "defined_tags", local.vpn_defaults.defined_tags)
            freeform_tags                    = lookup(input, "freeform_tags", local.vpn_defaults.freeform_tags)
            cpe_device_shape_id              = lookup(input, "cpe_device_shape_id", local.vpn_defaults.cpe_device_shape_id)
            ip_sec_cpe_local_identifier      = lookup(input, "ip_sec_cpe_local_identifier", local.vpn_defaults.ip_sec_cpe_local_identifier)
            ip_sec_cpe_local_identifier_type = lookup(input, "ip_sec_cpe_local_identifier_type", local.vpn_defaults.ip_sec_cpe_local_identifier_type)
        }
    ])
}

############################################################################
