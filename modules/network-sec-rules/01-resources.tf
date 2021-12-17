############################################################################
# Module Definition:
############################################################################
# Network Security Rule - Ingress ICMP:

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_ingress_icmp" {
  count                     = var.create_ingress_icmp ? 1 : 0
  network_security_group_id = var.net_sec_group_id
  direction                 = "INGRESS"
  protocol                  = "1"
  description               = var.net_sec_rule_desc
  source                    = var.net_sec_rule_source
  source_type               = var.net_sec_rule_source_type
  icmp_options {
    type = var.icmp_type
    code = var.icmp_code
  }
}

############################################################################
# Network Security Rule - Ingress TCP:

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_ingress_tcp" {
  count                     = var.create_ingress_tcp ? 1 : 0
  network_security_group_id = var.net_sec_group_id
  direction                 = "INGRESS"
  protocol                  = "6"
  description               = var.net_sec_rule_desc
  source                    = var.net_sec_rule_source
  source_type               = var.net_sec_rule_source_type
  tcp_options {
    destination_port_range {
      min = var.net_sec_rule_tcp_min
      max = var.net_sec_rule_tcp_max
    }
  }
}

############################################################################
# Network Security Rule - Ingress UDP:

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_ingress_udp" {
  count                     = var.create_ingress_udp ? 1 : 0
  network_security_group_id = var.net_sec_group_id
  direction                 = "INGRESS"
  protocol                  = "17"
  description               = var.net_sec_rule_desc
  source                    = var.net_sec_rule_source
  source_type               = var.net_sec_rule_source_type
  udp_options {
    destination_port_range {
      min = var.net_sec_rule_udp_min
      max = var.net_sec_rule_udp_max
    }
  }
}

############################################################################
# Network Security Rule - Egress ICMP:

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_egress_icmp" {
  count                     = var.create_egress_icmp ? 1 : 0
  network_security_group_id = var.net_sec_group_id
  direction                 = "EGRESS"
  protocol                  = "1"
  description               = var.net_sec_rule_desc
  destination               = var.net_sec_rule_dest
  destination_type          = var.net_sec_rule_dest_type
  icmp_options {
    type = var.icmp_type
    code = var.icmp_code
  }
}

############################################################################
# Network Security Rule - Egress TCP:

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_egress_tcp" {
  count                     = var.create_egress_tcp ? 1 : 0
  network_security_group_id = var.net_sec_group_id
  direction                 = "EGRESS"
  protocol                  = "6"
  description               = var.net_sec_rule_desc
  destination               = var.net_sec_rule_dest
  destination_type          = var.net_sec_rule_dest_type
  tcp_options {
    destination_port_range {
      min = var.net_sec_rule_tcp_min
      max = var.net_sec_rule_tcp_max
    }
  }
}

############################################################################
# Network Security Rule - Egress TCP All:

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_egress_tcp_all" {
  count                     = var.create_egress_tcp_all ? 1 : 0
  network_security_group_id = var.net_sec_group_id
  direction                 = "EGRESS"
  protocol                  = "6"
  description               = var.net_sec_rule_desc
  destination               = var.net_sec_rule_dest
  destination_type          = var.net_sec_rule_dest_type
}

############################################################################
# Network Security Rule - Egress UDP:

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_egress_udp" {
  count                     = var.create_egress_udp ? 1 : 0
  network_security_group_id = var.net_sec_group_id
  direction                 = "EGRESS"
  protocol                  = "17"
  description               = var.net_sec_rule_desc
  destination               = var.net_sec_rule_dest
  destination_type          = var.net_sec_rule_dest_type
  udp_options {
    destination_port_range {
      min = var.net_sec_rule_udp_min
      max = var.net_sec_rule_udp_max
    }
  }
}

############################################################################
# Egress - All:
resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_egress_all" {
  count                     = var.create_egress_all ? 1 : 0
  network_security_group_id = var.net_sec_group_id
  direction                 = "EGRESS"
  protocol                  = "all"
  description               = var.net_sec_rule_desc
  destination               = var.net_sec_rule_dest
  destination_type          = var.net_sec_rule_dest_type
}

############################################################################