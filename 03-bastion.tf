#
############################################################################
# Instance - V1 Bastion:
############################################################################

module "instance_bastion" {
  source                  = "./modules/core_instance"
  tenancy_id              = var.tenancy_ocid
  display_name            = "${var.customer_label}_bastion"
  vnic_hostname_label     = "${var.customer_label}bastion"
  shape                   = var.instance_shape_bastion
  shape_ocpus             = 1
  shape_mem               = 8
  availability_domain     = 2
  fault_domain            = 1
  compartment_id          = module.iam.compartments["finance_common_services"]
  subnet_id               = module.vcn.subnets["vcn1_sub_dmz"]
  network_sec_groups      = [oci_core_network_security_group.nsg_access.id,oci_core_network_security_group.nsg_v1_vpn.id, oci_core_network_security_group.nsg_prod_common.id]
  ssh_authorized_keys     = var.ssh_key_bastion
  source_id               = "ocid1.image.oc1.uk-london-1.aaaaaaaar3xlcex3lvy7rumdn6faglsjrsqgk6ifqbvud5nuc6wlwkkzohpa"
  boot_volume_size_in_gbs = 100
  assign_public_ip        = true
  #private_ip              = [local.ips.instances["opsView"]]
  boot_backup_policy      = "silver"
  defined_tags            = local.tags
}
############################################################################
