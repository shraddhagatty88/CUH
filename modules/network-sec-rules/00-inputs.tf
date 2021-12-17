############################################################################
# Module Input Variables:
############################################################################
# Group & Desc:

variable "net_sec_group_id" {}

variable "net_sec_rule_desc" {}

############################################################################
# Module Options:

variable "create_ingress_icmp" {
    default = false
}

variable "create_ingress_tcp" {
    default = false
}

variable "create_ingress_udp" {
    default = false
}

variable "create_egress_icmp" {
  default = false
}

variable "create_egress_tcp" {
  default = false
}

variable "create_egress_tcp_all" {
  default = false
}

variable "create_egress_all" {
  default = false
}

variable "create_egress_udp" {
  default = false
}

############################################################################
# Ingress Source:

variable "net_sec_rule_source" {
    default = ""
}

variable "net_sec_rule_source_type" {
    default = ""  # CIDR_BLOCK / SERVICE_CIDR_BLOCK / NETWORK_SECURITY_GROUP
}

############################################################################
# Egress Destination:

variable "net_sec_rule_dest" {
    default = ""
}

variable "net_sec_rule_dest_type" {
    default = ""  # CIDR_BLOCK / SERVICE_CIDR_BLOCK / NETWORK_SECURITY_GROUP
}

############################################################################
# ICMP Defaults:

variable "icmp_type" {
    default = 8   # Echo
}

variable "icmp_code" {
    default = 0   # Echo Reply
}

############################################################################
# TCP Ports:

variable "net_sec_rule_tcp_min" {
    default = ""
}

variable "net_sec_rule_tcp_max" {
    default = ""
}

############################################################################
# UDP Ports:

variable "net_sec_rule_udp_min" {
    default = ""
}

variable "net_sec_rule_udp_max" {
    default = ""
}

############################################################################