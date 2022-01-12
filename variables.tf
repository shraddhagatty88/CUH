############################################################################
# Variables:
############################################################################

############################################################################
# Tenancy:
############################################################################

variable "tenancy_ocid" {}
#variable "user_ocid" {}
#variable "fingerprint" {}
#variable "private_key_path" {}
variable "region" {}
variable "customer_label" {}
variable "compartment_id" {}

############################################################################
# IAM:
############################################################################

locals {
  compartments = {
    finance_common_services = {
      compartment_compartment = var.tenancy_ocid
      compartment_description = "${var.customer_label} Common Services"

    }
    finance_prod_services = {
      compartment_compartment = var.tenancy_ocid
      compartment_description = "${var.customer_label} Production Services"
      
    }
  }
  tag_namespaces = {
    Billing = {
      tag_namespace_compartment_id = module.iam.compartments["finance_common_services"]
      tag_namespace_description    = "Namespace for Billing tags"
      tags = {
        CostCentre = {
          tag_description      = "Internal Cost Centre"
          tag_is_cost_tracking = true
        }
       
      }
    }
 
  }
}

############################################################################
# Tags:
############################################################################

locals {
  tags = {
   
    "Billing.CostCentre"         = ""
   
  }
}



############################################################################
# Instances:
############################################################################

locals {
  
  oracle_images = {
    oel610_frankfurt  = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa3ckej2udki5yrov5pln4xg7z7bc6jwlmxx3mx2k5tmynnllb3jhq"
    oel79_frankfurt   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaf6gm7xvn7rhll36kwlotl4chm25ykgsje7zt2b4w6gae4yqfdfwa"
    # win2016_e3_london = "ocid1.image.oc1.uk-london-1.aaaaaaaa44tdm3ytd6coogcc3wpvvgpeothw3p4luvsmsi3l5ethcxkm6eiq"
  }
  shapes = {
    e2-1m = "VM.Standard.E2.1.Micro"
    e2-1  = "VM.Standard.E2.1"
    e2-2  = "VM.Standard.E2.2"
    e2-4  = "VM.Standard.E2.4"
    s2-1  = "VM.Standard2.1"
    s2-2  = "VM.Standard2.2"
    s2-4  = "VM.Standard2.4"
    s2-8  = "VM.Standard2.8"
    s2-16 = "VM.Standard2.16"
    e3    = "VM.Standard.E3.Flex"
  }
}

############################################################################
# VCN:
############################################################################

locals {
  vcns = {
    vcn1 = {
      vcn_dns_label      = "${var.customer_label}vcn"
      vcn_cidr_block     = var.ip_vcn
      vcn_compartment_id = module.iam.compartments["finance_common_services"]
      vcn_defined_tags   = local.tags
      subnets = {
        dmz = {
          subnet_cidr_block  = var.ip_sub_dmz
          subnet_dns_label   = "${var.customer_label}dmz"
          subnet_is_private  = false
          subnet_route_table = "dmz"
        }
        private = {
          subnet_cidr_block      = var.ip_sub_private
          subnet_dns_label       = "${var.customer_label}private"
          subnet_is_private      = true
          subnet_route_table     = "private"
        }
      }
      route_tables = {
        dmz = {
          route_rules =concat( 
        
            [for cidr in local.v1_domains : {
                route_rule_network_entity_id = "DRG"
                route_rule_destination       = cidr
                route_rule_destination_type  = "CIDR_BLOCK"
             }
            ],

            [for cidr in local.cust_domains : {
             
                route_rule_network_entity_id = "DRG"
                route_rule_destination       = cidr
                route_rule_destination_type  = "CIDR_BLOCK"
            
            
            }
            ]
            ,
            [{
              route_rule_network_entity_id = "IGW"
              route_rule_destination       = "0.0.0.0/0"
              route_rule_destination_type  = "CIDR_BLOCK"
            }])
          
        }

        private = {
          route_rules = concat (
            [for cidr in local.v1_domains : {
                route_rule_network_entity_id = "DRG"
                route_rule_destination       = cidr
                route_rule_destination_type  = "CIDR_BLOCK"
             }
            ],

            [for cidr in local.cust_domains : {
             
                route_rule_network_entity_id = "DRG"
                route_rule_destination       = cidr
                route_rule_destination_type  = "CIDR_BLOCK"
            
            }
            ],
            
            [ {
              route_rule_network_entity_id = "NAT"
              route_rule_destination       = "0.0.0.0/0"
              route_rule_destination_type  = "CIDR_BLOCK"
            },])  
        }
      }
    }
  }
}

############################################################################
# VPN:
############################################################################

locals {
  vpns = {
    v1_cl = {
      compartment_id       = module.iam.compartments["finance_common_services"]
      cpe_ip_address       = var.v1_cl_vpn
      ip_sec_drg_id        = module.vcn.drgs["vcn1_drg"]
      ip_sec_static_routes = [var.v1_cl_domain]
    }
    v1_cw = {
      compartment_id       = module.iam.compartments["finance_common_services"]
      cpe_ip_address       = var.v1_cw_vpn
      ip_sec_drg_id        = module.vcn.drgs["vcn1_drg"]
      ip_sec_static_routes = [var.v1_cw_domain]
    }
    cust1 = {
      compartment_id       = module.iam.compartments["finance_common_services"]
      cpe_ip_address       = var.cust1_vpn
      ip_sec_drg_id        = module.vcn.drgs["vcn1_drg"]
      ip_sec_static_routes = var.cust1_domain
    }
    cust2 = {
      compartment_id       = module.iam.compartments["finance_common_services"]
      cpe_ip_address       = var.cust2_vpn
      ip_sec_drg_id        = module.vcn.drgs["vcn1_drg"]
      ip_sec_static_routes = var.cust2_domain
    }
  }
}

############################################################################

############################################################################


#Compute Specific
#######################################
variable "availablity_domain" {
  default = "3"
}
variable "shape_ocpus" {
  default = 2
}
variable "shape_mem" {
  default = 16
}
variable "boot_volume_size_in_gbs" {
  default = 100
}
variable "backup_policy" {
  default = "silver"
}

#Opsview
variable "availablity_domain_opsview" {
  default = "1"
}
variable "shape_ocpus_opsview" {
  default = 1
}
variable "shape_mem_opsview" {
  default = 8
}
variable "boot_volume_size_in_gbs_opsview" {
  default = 100
}
variable "backup_policy_opsview" {
  default = "silver"
}
variable instance_shape_opsview {
    default = "VM.Standard.E2.1"
}
variable "linux_os_version_opsview" {
  default = "6.10"
}
#bastion
variable "instance_shape_bastion"{default = "VM.Standard.E2.1"}

variable "instance_os" {
  default = "Oracle Linux"
}
variable "linux_os_version_bastion" {
  default = "7.9"
}

###################################
#DB Specific
#########################################

variable "db_shapes" {}
variable "db_shape_ocpus" { }
variable "db_shape_mem" { }
variable "data_storage_size_in_gb" { }


#SSH Keys
####################################
variable "ssh_key_db" {}
variable "ssh_key_opsview"{}
variable "ssh_key_bastion"{}


############################################################################
# IPs:
############################################################################
variable "ip_vcn"{
   default =" "
}
variable "ip_sub_dmz"{
   default =" "
}
variable "ip_sub_private"{
   default =" "
}

locals {
  ips = {   
    access      = {
      v1_shraddha   = "49.37.160.172/32"
      v1_anthony = "80.233.59.184/32"
    }

   #To be raised through IRIS

   /*
    v1proxy     = {
      ip_v1_cl_vpn    = "95.45.180.36"
      ip_v1_cl_domain = "172.19.146.112/29"
      ip_v1_cw_vpn    = "159.134.94.228"
      ip_v1_cw_domain = "172.20.152.184/29"
    }
    v1_domains = {
      ip_v1_cl_domain = "172.19.146.112/29"
      ip_v1_cw_domain = "172.20.152.184/29"
    }
    gmp_vpn = {
      gmp_clayton_brook = "109.159.193.202"
    }
    gmp_domains = {
      gmp_domain_1 = "10.2.0.0/16"
      gmp_domain_2 = "10.4.0.0/16"
      gmp_domain_3 = "10.200.0.0/16"
      gmp_domain_4 = "10.210.0.0/16"
      gmp_domain_5 = "10.211.0.0/16"
      gmp_domain_6 = "10.220.0.0/16"
      gmp_domain_7 = "10.221.0.0/16"
      gmp_domain_8 = "10.230.0.0/17"
      gmp_domain_9 = "10.250.0.0/16"
      gmp_domain_10 = "10.251.0.0/16"
      gmp_domain_11 = "172.22.176.0/21"
      gmp_domain_12 = "172.22.184.0/22"
      gmp_domain_13 = "172.23.176.0/21"
      gmp_domain_14 = "172.23.184.0/22"
      gmp_domain_15 = "192.168.76.0/22"
      gmp_domain_16 = "192.168.176.0/21"
      gmp_domain_17 = "192.168.68.0/22"
      gmp_domain_18 = "192.168.168.0/22"
    }
      */
  }

}
###########################################
#VPN
###########################################
locals {

v1_vpns = ["${var.v1_cl_vpn}","${var.v1_cw_vpn}"]
cust_vpns = ["${var.cust1_vpn}","${var.cust2_vpn}"]
v1_domains = flatten([var.v1_cl_domain, var.v1_cw_domain])
cust_domains = flatten([var.cust1_domain, var.cust2_domain])

}

variable "v1_cl_vpn" {}
variable "v1_cw_vpn" {}


variable "cust1_vpn" {}
variable "cust2_vpn" {}

variable "v1_cl_domain" {
  type        = list(string)
  description = "List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG."
  default     = []
}
variable "v1_cw_domain" {
  type        = list(string)
  description = "List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG."
  default     = []
}

variable "cust1_domain" {
  type        = list(string)
  description = "List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG."
  default     = []
}
variable "cust2_domain" {
  type        = list(string)
  description = "List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG."
  default     = []
}
/*
variable "cust_vpns"{
  type        = list(string)
  description = "List of customer vpns"
  default     = []
}
variable "v1_vpns" {
  type        = list(string)
  description = "List of version 1 vpns"
  default     = []
  
}

variable "v1_domains" {
  type        = list(string)
  description = "V1 Domain"
  default     = [] 
}

variable "cust_domains" {
  type        = list(string)
  description = "List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG."
  default     = [] 
}


v1_vpns = ["${var.v1_cl}","${var.v1_cw}"]
cust_vpns = ["${var.cust1_vpn}","${var.cust2_vpn}"]
v1_domains = flatten(var.v1_cl_domain, var.v1_cw_domain)
cust_domains = flatten(var.cust1_domin, var.cust2.domain)

*/
variable "access" {

  type        = list(string)
  description = "List of access IPs allowed to connect "
  default     = []

}

/*
####################################
#Bastion
#####################################

variable "public_src_bastion_cidrs" {
  type        = list(string)
  default     = []
  description = "External IP ranges in CIDR notation allowed to make SSH inbound connections. 0.0.0.0/0 is not allowed in the list."
  validation {
    condition     = !contains(var.public_src_bastion_cidrs, "0.0.0.0/0") && length([for c in var.public_src_bastion_cidrs : c if length(regexall("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", c)) > 0]) == length(var.public_src_bastion_cidrs)
    error_message = "Validation failed for public_src_bastion_cidrs: values must be in CIDR notation, all different than 0.0.0.0/0."
  }
}


##################
#Cloud Guard
##################
variable "policies_in_root_compartment" {
  type        = string
  default     = "CREATE"
  description = "Whether required grants at the root compartment should be created or simply used. Valid values: 'CREATE' and 'USE'. If 'CREATE', make sure the user executing this stack has permissions to create grants in the root compartment. If 'USE', no grants are created."
  validation {
    condition     = contains(["CREATE", "USE"], var.policies_in_root_compartment)
    error_message = "Validation failed for policies_in_root_compartment: valid values are CREATE or USE."
  }
}

variable "cloud_guard_configuration_status" {
  default     = "ENABLE"
  description = "Determines whether Cloud Guard should be enabled in the tenancy. If 'ENABLE', a target is created for the Root compartment."
  validation {
    condition     = contains(["ENABLE", "DISABLE"], upper(var.cloud_guard_configuration_status))
    error_message = "Validation failed for cloud_guard_configuration_status: valid values (case insensitive) are ENABLE or DISABLE."
  }
}

####################################
# Vulnerability Scanning Service
####################################

variable "vss_create" {
  description = "Whether or not Vulnerability Scanning Service recipes and targets are to be created in the Landing Zone."
  type        = bool
  default     = true
}
variable "vss_scan_schedule" {
  description = "The scan schedule for the Vulnerability Scanning Service recipe, if enabled. Valid values are WEEKLY or DAILY (case insensitive)."
  type        = string
  default     = "WEEKLY"
  validation {
    condition     = contains(["WEEKLY", "DAILY"], upper(var.vss_scan_schedule))
    error_message = "Validation failed for vss_scan_schedule: valid values are WEEKLY or DAILY (case insensitive)."
  }
}
variable "vss_scan_day" {
  description = "The week day for the Vulnerability Scanning Service recipe, if enabled. Only applies if vss_scan_schedule is WEEKLY (case insensitive)."
  type        = string
  default     = "SUNDAY"
  validation {
    condition     = contains(["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"], upper(var.vss_scan_day))
    error_message = "Validation failed for vss_scan_day: valid values are SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY (case insensitive)."
  }
}

################################
#Notifications and Events
#################################
variable "network_admin_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for all network related notifications."
  validation {
    condition     = length([for e in var.network_admin_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.network_admin_email_endpoints)
    error_message = "Validation failed network_admin_email_endpoints: invalid email address."
  }
}
*/