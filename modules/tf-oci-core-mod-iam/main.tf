############################################################################
# OCI - Core Module - IAM - Main:
############################################################################

############################################################################
# Compartments:
############################################################################

resource "oci_identity_compartment" "compartment" {
    for_each = {
        for param in local.compartment_params : param.compartment_key => param
    }
    
    compartment_id = each.value.compartment_compartment
    description    = each.value.compartment_description
    name           = each.key
    defined_tags   = each.value.compartment_defined_tags
    freeform_tags  = each.value.compartment_freeform_tags

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
# Tag Namespaces:
############################################################################

resource "oci_identity_tag_namespace" "tag_namespace" {
    for_each = {
        for param in local.tag_namespace_params : param.tag_namespace_key => param
    }

    compartment_id = each.value.tag_namespace_compartment_id
    description    = each.value.tag_namespace_description
    name           = each.key
    is_retired     = each.value.tag_namespace_is_retired
}

############################################################################
# Tags:
############################################################################

resource "oci_identity_tag" "tag" {
    for_each = {
        for param in local.tag_params : param.tag_key => param
    }
    
    tag_namespace_id = oci_identity_tag_namespace.tag_namespace[each.value.tag_namespace_key].id
    description      = each.value.tag_description
    name             = each.key
    is_cost_tracking = each.value.tag_is_cost_tracking
    is_retired       = each.value.tag_is_retired
    # validator {
    #     validator_type = "${var.tag_validator_validator_type}"
    #     values         = "${var.tag_validator_values}"
    # }
}

############################################################################
