############################################################################
# Instance - V1 OpsView:
############################################################################

module "instance_opsview" {
  source                  = "./modules/core_instance"
  tenancy_id              = var.tenancy_ocid
  display_name            = "${var.customer_label}_opsview"
  vnic_hostname_label     = "${var.customer_label}opsview"
  shape                   = "VM.Standard.E2.1"
  shape_ocpus             = 1
  shape_mem               = 8
  availability_domain     = 1
  fault_domain            = 1
  compartment_id          = module.iam.compartments["finance_common_services"]
  subnet_id               = module.vcn.subnets["vcn1_sub_dmz"]
  network_sec_groups      = [oci_core_network_security_group.nsg_access.id,oci_core_network_security_group.nsg_v1_vpn.id, oci_core_network_security_group.nsg_prod_common.id]
  ssh_authorized_keys     = file(local.ssh_keys["access"])
  source_id               = data.oci_core_images.OSImage_opsview.id
  boot_volume_size_in_gbs = 100
  assign_public_ip        = true
  #private_ip              = [local.ips.instances["opsView"]]
  boot_backup_policy      = "silver"
  defined_tags            = local.tags
}
############################################################################