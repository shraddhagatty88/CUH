#
############################################################################
# Instance - V1 Bastion:
############################################################################

module "instance_bastion" {
  source                  = "./modules/core_instance"
  tenancy_id              = var.tenancy_ocid
  display_name            = "${var.customer_label}bastion"
  vnic_hostname_label     = "${var.customer_label}bastion"
  shape                   = var.instance_shape
  shape_ocpus             = var.shape_ocpus
  shape_mem               = var.shape_mem
  availability_domain     = var.availablity_domain
  fault_domain            = 1
  compartment_id          = module.iam.compartments["common_services"]
  subnet_id               = module.vcn.subnets["vcn1_sub_dmz"]
  network_sec_groups      = [oci_core_network_security_group.nsg_access.id,oci_core_network_security_group.nsg_v1_vpn.id, oci_core_network_security_group.nsg_prod_common]
  ssh_authorized_keys     = var.ssh_key
  source_id               = "ocid1.image.oc1.uk-london-1.aaaaaaaahm2udvgllrsptv6q3afrduo6tpuqa2ti6fcst5gt3myc7zsfocmq"
  boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  assign_public_ip        = true
  #private_ip              = [local.ips.instances["opsView"]]
  boot_backup_policy      = var.backup_policy
  defined_tags            = local.tags
}
############################################################################