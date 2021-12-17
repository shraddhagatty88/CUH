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

############################################################################
# IAM:
############################################################################

locals {
  compartments = {
    common_services = {
      compartment_compartment = var.tenancy_ocid
      compartment_description = "${var.customer_label} Common Services"
    }
    prod_services = {
      compartment_compartment = var.tenancy_ocid
      compartment_description = "${var.customer_label} Production Services"
    }
    nprd_services = {
      compartment_compartment = var.tenancy_ocid
      compartment_description = "${var.customer_label} Non-Production Services"
    }
  }
  tag_namespaces = {
    Billing = {
      tag_namespace_compartment_id = module.iam.compartments["common_services"]
      tag_namespace_description    = "Namespace for Billing tags"
      tags = {
        CostCentre = {
          tag_description      = "Internal Cost Centre"
          tag_is_cost_tracking = true
        }
        Workload = {
          tag_description      = "Workload Type"
          tag_is_cost_tracking = true
        }
        Environment = {
          tag_description      = "Environment Type"
          tag_is_cost_tracking = true
        }
      }
    }
    Account = {
      tag_namespace_compartment_id = module.iam.compartments["common_services"]
      tag_namespace_description    = "Namespace for Account tags"
      tags = {
        StackName = {
          tag_description      = "Product/Environment title"
        }
        StackOwner = {
          tag_description      = "Product Owner"
        }
        ProjectName = {
          tag_description      = "Internal project title"
        }
        BillingOwner = {
          tag_description      = "Full name of person who administers this instance"
        }
        CompartmentName = {
          tag_description      = "The compartment the resource belongs to"
        }
      }
    }
    Schedule = {
      tag_namespace_compartment_id = module.iam.compartments["common_services"]
      tag_namespace_description    = "Namespace for Scheduling tags"
      tags = {
        AnyDay = {
          tag_description      = "Tag for AnyDay scheduling"
        }
        WeekDay = {
          tag_description      = "Tag for WeekDay scheduling"
        }
        Weekend = {
          tag_description      = "Tag for Weekend scheduling"
        }
        Monday = {
          tag_description      = "Tag for Monday scheduling"
        }
        Tuesday = {
          tag_description      = "Tag for Tuesday scheduling"
        }
        Wednesday = {
          tag_description      = "Tag for Wednesday scheduling"
        }
        Thursday = {
          tag_description      = "Tag for Thursday scheduling"
        }
        Friday = {
          tag_description      = "Tag for Friday scheduling"
        }
        Saturday = {
          tag_description      = "Tag for Saturday scheduling"
        }
        Sunday = {
          tag_description      = "Tag for Sunday scheduling"
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
    "Account.StackName"          = var.StackName
    "Account.StackOwner"         = var.StackOwner
    "Account.ProjectName"        = var.ProjectName
    "Account.BillingOwner"       = var.BillingOwner
    "Account.CompartmentName"    = var.CompartmentName
    "Billing.CostCentre"         = var.CostCentre
    "Billing.Workload"           = var.Workload
    "Billing.Environment"        = var.Environment
  }
}

variable "StackName" {
    default = ""
}
variable "StackOwner" {
    default = ""
}
variable "ProjectName" {
    default = ""
}
variable "BillingOwner" {
    default = ""
}
variable "CostCentre" {
    default = ""
}
variable "Workload" {
    default = ""
}
variable "Environment"{
    default =""
}
variable "CompartmentName"{
  default =""
}
############################################################################
# IPs:
############################################################################
variable "ip_vcn"{
   default =" "
}
variable "ip_sub_lb_int"{
   default =" "
}
variable "ip_sub_fss"{
   default =" "
}
variable "ip_sub_dmz"{
   default =" "
}
variable "ip_sub_app"{ 
  default =" "
}
variable "ip_sub_db"{
   default =" "
}

locals {
  ips = {   
    access      = {
      v1_anthony   = "37.228.201.25/32"
      v1_anthony_2 = "80.233.59.184/32"
      v1_jason     = "86.161.198.151/32"
      v1_steve_w   = "80.229.0.228/32"
      v1_anton     = "79.66.207.212/32"
      v1_claudia   = "37.156.75.221/32"
      v1_david     = "90.249.73.255/32"
      v1_michael   = "188.220.209.229/32"
      v1_mark      = "151.224.254.204/32"
    }
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
    gmp_dns = {
      gmp_node1_datacentre01 = "10.221.69.63"   
      gmp_node1_datacentre02 = "10.2.9.36"   
      vcn_resolver           = "169.254.169.254"   
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
  }
}

variable "v1proxy" {
  type        = list(string)
  description = "List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG."
  default     = []
  
}

variable "domain" {
  type        = list(string)
  description = "List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG."
  default     = []
  
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
  gmp_domain = "GMP.Police.UK"
}

############################################################################
# VCN:
############################################################################

locals {
  vcns = {
    vcn1 = {
      vcn_dns_label      = "${var.customer_label}vcn"
      vcn_cidr_block     = var.ip_vcn
      vcn_compartment_id = module.iam.compartments["common_services"]
      vcn_defined_tags   = local.tags
      subnets = {
        dmz = {
          subnet_cidr_block  = var.ip_sub_dmz
          subnet_dns_label   = "${var.customer_label}dmz"
          subnet_is_private  = false
          subnet_route_table = "dmz"
        }
        app = {
          subnet_cidr_block      = var.ip_sub_app
          subnet_dns_label       = "${var.customer_label}app"
          subnet_is_private      = true
          subnet_route_table     = "app"
        }
        db = {
          subnet_cidr_block       = var.ip_sub_db
          subnet_dns_label        = "${var.customer_label}db"
          subnet_is_private       = true
          subnet_route_table      = "db"
        }
        lbint = {
          subnet_cidr_block       = var.ip_sub_lb_int
          subnet_dns_label        = "${var.customer_label}lbint"
          subnet_is_private       = true
          subnet_route_table      = "app"
        }
        fss = {
          subnet_cidr_block       = var.ip_sub_fss
          subnet_dns_label        = "${var.customer_label}fss"
          subnet_is_private       = true
          subnet_route_table      = "app"
        }
      }
      route_tables = {
        dmz = {
          route_rules =concat( 
        
            [for cidr in var.v1proxy : {
                route_rule_network_entity_id = "DRG"
                route_rule_destination       = cidr
                route_rule_destination_type  = "CIDR_BLOCK"
             }
            ],

            [for cidr in var.domain : {
             
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
        app = {
          route_rules = concat (
            [for cidr in var.v1proxy : {
                route_rule_network_entity_id = "DRG"
                route_rule_destination       = cidr
                route_rule_destination_type  = "CIDR_BLOCK"
             }
            ],

            [for cidr in var.domain : {
             
                route_rule_network_entity_id = "DRG"
                route_rule_destination       = cidr
                route_rule_destination_type  = "CIDR_BLOCK"
            
            
            }
            ])
            
        }

        db = {
          route_rules = concat (
            [for cidr in var.v1proxy : {
                route_rule_network_entity_id = "DRG"
                route_rule_destination       = cidr
                route_rule_destination_type  = "CIDR_BLOCK"
             }
            ],

            [for cidr in var.domain : {
             
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
      compartment_id       = module.iam.compartments["common_services"]
      cpe_ip_address       = local.ips.v1proxy["ip_v1_cl_vpn"]
      ip_sec_static_routes = [local.ips.v1proxy["ip_v1_cl_domain"]]
    }
    v1_cw = {
      compartment_id       = module.iam.compartments["common_services"]
      cpe_ip_address       = local.ips.v1proxy["ip_v1_cw_vpn"]
      ip_sec_static_routes = [local.ips.v1proxy["ip_v1_cw_domain"]]
    }
    gmp_cb = {
      compartment_id       = module.iam.compartments["common_services"]
      cpe_ip_address       = local.ips.gmp_vpn["gmp_clayton_brook"]
      ip_sec_static_routes = [local.ips.gmp_domains["gmp_domain_1"]
                             ,local.ips.gmp_domains["gmp_domain_2"]
                             ,local.ips.gmp_domains["gmp_domain_3"]
                             ,local.ips.gmp_domains["gmp_domain_4"]
                             ,local.ips.gmp_domains["gmp_domain_5"]
                             ,local.ips.gmp_domains["gmp_domain_6"]
                             ,local.ips.gmp_domains["gmp_domain_7"]
                             ,local.ips.gmp_domains["gmp_domain_8"]
                             ,local.ips.gmp_domains["gmp_domain_9"]
                             ,local.ips.gmp_domains["gmp_domain_10"]
                             ,local.ips.gmp_domains["gmp_domain_11"]
                             ,local.ips.gmp_domains["gmp_domain_12"]
                             ,local.ips.gmp_domains["gmp_domain_13"]
                             ,local.ips.gmp_domains["gmp_domain_14"]
                             ,local.ips.gmp_domains["gmp_domain_15"]
                             ,local.ips.gmp_domains["gmp_domain_16"]
                             ,local.ips.gmp_domains["gmp_domain_17"]
                             ,local.ips.gmp_domains["gmp_domain_18"]]
    }
  }
}

############################################################################
