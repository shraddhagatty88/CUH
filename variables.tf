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
  }
}
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

   #To raised through IRIS
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
    cuh_vpn = {
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
        private = {
          subnet_cidr_block      = var.ip_sub_app
          subnet_dns_label       = "${var.customer_label}app"
          subnet_is_private      = true
          subnet_route_table     = "app"
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

#SSH Keys
variable "ssh_key_db" {}
variable "ssh_key" {}

#Compute Specific
variable "availablity_domain_name" {
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
variable instance_shape {
    default = "VM.Standard.E2.1"
}

#DB Specific
shape                   = var.db_shapes
  shape_ocpus             = var.db_shape_ocpus
  shape_mem               = var.db_shape_mem

variable "db_shapes" {
  
}

variable "db_shape_ocpus" {
  
}

variable "db_shape_mem" {
  
}

variable "data_storage_size_in_gb" {
  
}