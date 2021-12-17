############################################################################
# OCI - Core Module - IAM - Variables:
############################################################################

############################################################################
# Compartments:
############################################################################

variable "iam_compartments" {}

locals {
    compartment_defaults = {
        compartment_defined_tags  = {}
        compartment_freeform_tags = {}
    }
    compartment_params = flatten([
        for compartment_key, compartment in var.iam_compartments : {
            compartment_key           = compartment_key
            compartment_compartment   = compartment.compartment_compartment
            compartment_description   = compartment.compartment_description
            
            compartment_defined_tags  = lookup(compartment, "compartment_defined_tags", local.compartment_defaults.compartment_defined_tags)
            compartment_freeform_tags = lookup(compartment, "compartment_freeform_tags", local.compartment_defaults.compartment_freeform_tags)
        }
    ])
}

############################################################################
# Tags:
############################################################################

variable "iam_tag_namespaces" {}

locals {
    tag_defaults = {
        tag_namespace_is_retired  = false
        tag_is_cost_tracking      = false
        tag_is_retired            = false
    }
    tag_namespace_params = flatten([
        for tag_namespace_key, tag_namespace in var.iam_tag_namespaces : {
            tag_namespace_key            = tag_namespace_key
            tag_namespace_compartment_id = tag_namespace.tag_namespace_compartment_id
            tag_namespace_description    = tag_namespace.tag_namespace_description
            
            tag_namespace_is_retired     = lookup(tag_namespace, "tag_namespace_is_retired", local.tag_defaults.tag_namespace_is_retired)
        }
    ])
    tag_params = flatten([
        for tag_namespace_key, tag_namespace in var.iam_tag_namespaces : [
            for tag_key, tag in tag_namespace.tags : {
                tag_namespace_key    = tag_namespace_key
                tag_key              = tag_key
                tag_description      = tag.tag_description
                
                tag_is_cost_tracking = lookup(tag, "tag_is_cost_tracking", local.tag_defaults.tag_is_cost_tracking)
                tag_is_retired       = lookup(tag, "tag_is_retired", local.tag_defaults.tag_is_retired)
            }
        ]
    ])
}

############################################################################
# Groups:
############################################################################

# variable "iam_groups" {
#     type = map(object({
#         group_compartment = string
#         group_description = string
#         group_name        = string
#     }))
# }

############################################################################
# Dynamic Groups:
############################################################################

# variable "iam_dynamic_groups" {
#     type = map(object({
#         dynamic_group_compartment   = string
#         dynamic_group_description   = string
#         dynamic_group_matching_rule = string
#         dynamic_group_name          = string
#     }))
# }

############################################################################
# Policies:
############################################################################

# variable "iam_policies" {
#     type = map(object({
#         policy_compartment = string
#         policy_description = string
#         policy_name        = string
#         policy_statements  = list(string)
#     }))
# }

############################################################################
# Users:
############################################################################

# variable "iam_users" {
#     type = map(object({
#         user_compartment = string
#         user_description = string
#         user_name        = string
#         user_email       = string
#         # capabilities     = map(bool({
#         #     can_use_api_keys             = bool
#         #     can_use_auth_tokens          = bool
#         #     can_use_console_password     = bool
#         #     can_use_customer_secret_keys = bool
#         #     can_use_smtp_credentials     = bool
#         # }))
#     }))
# }

############################################################################