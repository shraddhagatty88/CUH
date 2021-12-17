############################################################################
# Module - OCI IAM - Main:
############################################################################

############################################################################
# Tag Namespaces:
############################################################################

resource "oci_identity_tag_namespace" "tag_namespace" {
    for_each       = var.iam_tag_namespaces

    compartment_id = each.value.tag_namespace_compartment
    description    = each.value.tag_namespace_description
    name           = each.value.tag_namespace_name
    is_retired     = each.value.tag_namespace_is_retired
}

############################################################################
# Tags:
############################################################################

locals {
    tag_namespace_tags = flatten([
        for tag_namespace_key, tag_namespace in var.iam_tag_namespaces : [
            for tag_key, tag in tag_namespace.tag_namespace_tags : {
                tag_namespace_key    = tag_namespace_key
                tag_key              = tag_key
                tag_namespace_id     = oci_identity_tag_namespace.tag_namespace[tag_namespace_key].id
                tag_description      = tag.tag_description
                tag_name             = tag.tag_name
                tag_is_cost_tracking = tag.tag_is_cost_tracking
                tag_is_retired       = tag.tag_is_retired
            }  
        ]
    ])
}

resource "oci_identity_tag" "tag" {
    for_each = {
        for tag in local.tag_namespace_tags : "${tag.tag_namespace_key}_${tag.tag_key}" => tag
    }
    
    tag_namespace_id = each.value.tag_namespace_id
    description      = each.value.tag_description
    name             = each.value.tag_name
    is_cost_tracking = each.value.tag_is_cost_tracking
    is_retired       = each.value.tag_is_retired
    # validator {
    #     validator_type = "${var.tag_validator_validator_type}"
    #     values         = "${var.tag_validator_values}"
    # }
}

#################################################################################
###### Tags Defaults:
#################################################################################
#####
#####locals {
#####    tag_defaults = flatten([
#####        for tag_namespace_key, tag_namespace in var.iam_tag_namespaces : [
#####            for tag_key, tag in tag_namespace.tag_namespace_tags : [
#####                for tag_default_key, tag_default in tag.tag_default : {
#####                    tag_namespace_key       = tag_namespace_key
#####                    tag_key                 = tag_key
#####                    tag_default_key         = tag_default_key
#####                    compartment_id          = oci_identity_tag_namespace.tag_namespace[tag_namespace_key].compartment_id
#####                    tag_definition_id       = oci_identity_tag.tag[join("",[tag_namespace_key,"_",tag_key])].id
#####                    tag_default_value       = tag_default.tag_default_value
#####                    tag_default_is_required = tag_default.tag_default_is_required
#####                }
#####            ]  
#####        ]
#####    ])
#####}
#####
#####resource "oci_identity_tag_default" "tag_default" {
#####    for_each = {
#####        for tag_default in local.tag_defaults : "${tag_default.tag_namespace_key}_${tag_default.tag_default_key}" => tag_default
#####    }
#####
#####    compartment_id    = each.value.compartment_id
#####    tag_definition_id = each.value.tag_definition_id
#####    value             = each.value.tag_default_value
#####    is_required       = each.value.tag_default_is_required
#####}
#####
#################################################################################
###### Compartments:
#################################################################################

resource "oci_identity_compartment" "compartment" {
    for_each       = var.iam_compartments
    
    compartment_id = each.value.compartment_compartment
    description    = each.value.compartment_description
    name           = each.value.compartment_name
    
    defined_tags   = var.defined_tags
    freeform_tags  = var.freeform_tags

    lifecycle {
        ignore_changes = [
            # Oracle-Tags Namespace & Defined Tags to be defined to allow ignore_changes
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
        ]
    }
}

################################################################################
##### Groups:
################################################################################
####
####resource "oci_identity_group" "group" {
####    for_each       = var.iam_groups
####    
####    compartment_id = each.value.group_compartment
####    description    = each.value.group_description
####    name           = each.value.group_name
####    
####    defined_tags   = var.defined_tags
####    freeform_tags  = var.freeform_tags
####    
####    lifecycle {
####        ignore_changes = [
####            defined_tags["Oracle-Tags.CreatedBy"],
####            defined_tags["Oracle-Tags.CreatedOn"],
####        ]
####    }
####}
####
################################################################################
##### Dynamic Groups:
################################################################################
####
####resource "oci_identity_dynamic_group" "dynamic_group" {
####    for_each       = var.iam_dynamic_groups
####
####    compartment_id = each.value.dynamic_group_compartment
####    description    = each.value.dynamic_group_description
####    matching_rule  = each.value.dynamic_group_matching_rule
####    name           = each.value.dynamic_group_name
####    
####    defined_tags   = var.defined_tags
####    freeform_tags  = var.freeform_tags
####
####    lifecycle {
####        ignore_changes = [
####            defined_tags["Oracle-Tags.CreatedBy"],
####            defined_tags["Oracle-Tags.CreatedOn"],
####        ]
####    }
####}
####
################################################################################
##### Policies:
################################################################################
####
####resource "oci_identity_policy" "policy" {
####    for_each       = var.iam_policies
####
####    compartment_id = each.value.policy_compartment
####    description    = each.value.policy_description
####    name           = each.value.policy_name
####    statements     = each.value.policy_statements
####    
####    defined_tags   = var.defined_tags
####    freeform_tags  = var.freeform_tags
####
####    lifecycle {
####        ignore_changes = [
####            defined_tags["Oracle-Tags.CreatedBy"],
####            defined_tags["Oracle-Tags.CreatedOn"],
####        ]
####    }
####}
####
################################################################################
##### Users:
################################################################################
####
####resource "oci_identity_user" "user" {
####    for_each       = var.iam_users
####
####    compartment_id = each.value.user_compartment
####    description    = each.value.user_description
####    name           = each.value.user_name
####    email          = each.value.user_email
####  
####    defined_tags   = var.defined_tags
####    freeform_tags  = var.freeform_tags
####  
####    lifecycle {
####        ignore_changes = [
####            defined_tags["Oracle-Tags.CreatedBy"],
####            defined_tags["Oracle-Tags.CreatedOn"],
####        ]
####    }
####}
####
################################################################################
##### User Capabilities:
################################################################################
####
##### resource "oci_identity_user_capabilities_management" "user_capabilities_management" {
#####     #Required
#####     user_id                      = "${oci_identity_user.user1.id}"
####
#####     #Optional 
#####     can_use_api_keys             = "true"
#####     can_use_auth_tokens          = "true"
#####     can_use_console_password     = "false"
#####     can_use_customer_secret_keys = "true"
#####     can_use_smtp_credentials     = "true"
##### }
####
################################################################################
