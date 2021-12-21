############################################################################
# Instance - V1 OpsView:
############################################################################

module "instance_opsview" {
  source                  = "./modules/core_instance"
  tenancy_id              = var.tenancy_ocid
  display_name            = "${var.customer_label}_opsview"
  vnic_hostname_label     = "${var.customer_label}opsview"
  shape                   = var.aw_shapes["E2_1"]
  shape_ocpus             = 1
  shape_mem               = 8
  availability_domain     = 1
  fault_domain            = 1
  compartment_id          = module.compartment-common-services.compartment_id
  subnet_id               = module.subnet_ext.subnet_id
  network_sec_groups      = [module.security_group_ext.group_id, module.security_group_v1_vpn.group_id]
  ssh_authorized_keys     = file(var.access_keys["opsview"])
  source_id               = var.aw_images["linux_6"]
  boot_volume_size_in_gbs = 100
  assign_public_ip        = true
  #private_ip              = [local.ips.instances["opsView"]]
  boot_backup_policy      = "silver"
  defined_tags            = var.tags_common
}

############################################################################