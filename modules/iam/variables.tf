############################################################################
# Module - OCI IAM - Variables:
############################################################################

############################################################################
# General:
############################################################################

#variable "tenancy_ocid" {
#    type    = string
#}
#
#variable "defined_tags" {
#    type    = map(string)
#    default = {}
#}
#
#variable "freeform_tags" {
#    type    = map(string)
#    default = {}
#}

############################################################################
# Tags:
############################################################################

variable "iam_tag_namespaces" {
    type = map(object({
        tag_namespace_compartment = string
        tag_namespace_description = string
        tag_namespace_name        = string
        tag_namespace_is_retired  = bool
        tag_namespace_tags        = map(object({
            tag_description       = string
            tag_name              = string
            tag_is_cost_tracking  = bool
            tag_is_retired        = bool
            tag_default           = map(object({  
                tag_default_value       = string
                tag_default_is_required = bool
            }))
        }))
    }))
}
# tag_default:  (try map(any) to avoid this name/header field?)

############################################################################
# Compartments:
############################################################################

variable "iam_compartments" {
    type = map(object({
        compartment_compartment = string
        compartment_description = string
        compartment_name        = string
    }))
}

################################################################################
##### Groups:
################################################################################
####
####variable "iam_groups" {
####    type = map(object({
####        group_compartment = string
####        group_description = string
####        group_name        = string
####    }))
####}
####
################################################################################
##### Dynamic Groups:
################################################################################
####
####variable "iam_dynamic_groups" {
####    type = map(object({
####        dynamic_group_compartment   = string
####        dynamic_group_description   = string
####        dynamic_group_matching_rule = string
####        dynamic_group_name          = string
####    }))
####}
####
################################################################################
##### Policies:
################################################################################
####
####variable "iam_policies" {
####    type = map(object({
####        policy_compartment = string
####        policy_description = string
####        policy_name        = string
####        policy_statements  = list(string)
####    }))
####}
####
################################################################################
##### Users:
################################################################################
####
####variable "iam_users" {
####    type = map(object({
####        user_compartment = string
####        user_description = string
####        user_name        = string
####        user_email       = string
####        # capabilities     = map(bool({
####        #     can_use_api_keys             = bool
####        #     can_use_auth_tokens          = bool
####        #     can_use_console_password     = bool
####        #     can_use_customer_secret_keys = bool
####        #     can_use_smtp_credentials     = bool
####        # }))
####    }))
####}
####
################################################################################
