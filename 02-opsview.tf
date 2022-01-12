############################################################################
# Instance - V1 OpsView:
############################################################################

module "instance_opsview" {
  source                  = "./modules/core_instance"
  tenancy_id              = var.tenancy_ocid
  display_name            = "${var.customer_label}_opsview"
  vnic_hostname_label     = "${var.customer_label}opsview"
  shape                   = var.instance_shape_opsview
  shape_ocpus             = var.shape_ocpus_opsview
  shape_mem               = var.shape_mem_opsview
  availability_domain     = var.availablity_domain_opsview
  fault_domain            = 1
  compartment_id          = module.iam.compartments["finance_common_services"]
  subnet_id               = module.vcn.subnets["vcn1_sub_dmz"]
  network_sec_groups      = [oci_core_network_security_group.nsg_access.id,oci_core_network_security_group.nsg_v1_vpn.id, oci_core_network_security_group.nsg_prod_common.id]
  ssh_authorized_keys     = var.ssh_key_opsview
  source_id               = data.oci_core_images.OSImage_opsview.id
  boot_volume_size_in_gbs = var.boot_volume_size_in_gbs_opsview
  assign_public_ip        = true
  #private_ip              = [local.ips.instances["opsView"]]
  boot_backup_policy      = var.backup_policy_opsview
  defined_tags            = local.tags
}
############################################################################