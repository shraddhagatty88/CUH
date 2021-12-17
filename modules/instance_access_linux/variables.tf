variable instance_availability_domain {}
variable instance_name                {}
variable private_ip                   {}
variable fault_domain                 {}
variable network_sec_groups           {}
variable dmz_subnet                   { default="ocid1.subnet.oc1.uk-london-1.aaaaaaaan5k3xtmt5gbl7s4jeamwangbxwzczlqgsuxddq3srncongi2mbrq" }
variable common_services_compartment  { default="ocid1.compartment.oc1..aaaaaaaawt2mevjktp73ohwa2kz64queencxg6r6vwdaqleeldap6dxawwna" }
variable ssh_authorized_keys          { default="/home/gmp/terraform/gmp-common-services/files/ssh_gmp_access.pub" }
