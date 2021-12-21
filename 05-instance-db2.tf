############################################################################
# TEST - EBS International Database:
############################################################################

module "instance_test_ebs_intl_db" {
  source                  = "./modules/core_instance"
  tenancy_id              = var.tenancy_ocid
  display_name            = "ocieitebsdb"
  vnic_hostname_label     = "ocieitebsdb"
  shape                   = local.shapes["e3"]
  shape_ocpus             = 4
  shape_mem               = 33
  availability_domain     = 2
  fault_domain            = 3
  compartment_id          = data.terraform_remote_state.common_services.outputs.nprd_services_compartment_id
  subnet_id               = data.terraform_remote_state.common_services.outputs.nprd_subnet_db_id
  network_sec_groups      = [data.terraform_remote_state.common_services.outputs.nsg_nprd_common_id
                            ,data.terraform_remote_state.common_services.outputs.nsg_nprd_db_id
                            ,data.terraform_remote_state.common_services.outputs.nsg_nprd_wood_access_id
                            ,data.terraform_remote_state.common_services.outputs.nsg_nprd_v1_vpn_id]
  ssh_authorized_keys     = file(local.ssh_keys["nprd"])
  source_id               = data.oci_core_images.v1_oel79_golden_image_ebs_sit.images[0].id
  boot_volume_size_in_gbs = 100
  assign_public_ip        = false
  boot_backup_policy      = "silver"
  private_ip              = [local.ips.instances["ebs_intl_test_db"]]
  defined_tags            = merge(
                            local.tags["nprd_ebs_intl"]
                            ,map("Schedule.AnyDay", "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1") # TMP: ON (24x7)
                            # ,map("Schedule.WeekDay", "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1") # BAU: ON (M-F 6-6)
                            )
}

############################################################################
# VG01 - /archive

data "oci_core_volume_backups" "instance_test_ebs_intl_db_VG01_backup" {
    compartment_id = data.terraform_remote_state.common_services.outputs.prod_services_compartment_id
    # volume_id      = 
    display_name   = "ocieipebsdb01_VG01_backup_20210216_212857"
}

module "instance_test_ebs_intl_db_VG01" {
  source              = "./modules/core_volume"
  tenancy_id          = var.tenancy_ocid
  volume_display_name = "ocieitebsdb_VG01"
  availability_domain = module.instance_test_ebs_intl_db.core_instance_ad[0]
  compartment_id      = module.instance_test_ebs_intl_db.core_instance_compartment[0]
  backup_policy       = "silver"
  size_in_gbs         = 1000
  defined_tags        = local.tags["nprd_ebs_intl"]
  source_details = {
    source_id    = data.oci_core_volume_backups.instance_test_ebs_intl_db_VG01_backup.volume_backups.0.id
    source_type  = "volumeBackup" 
  }
}

resource "oci_core_volume_attachment" "instance_test_ebs_intl_db_VG01_attach" {
  instance_id     = module.instance_test_ebs_intl_db.core_instance_ids[0]
  volume_id       = module.instance_test_ebs_intl_db_VG01.core_volume_ids[0]
  device          = "/dev/oracleoci/oraclevdb"
  attachment_type = "paravirtualized"
}

############################################################################
# VG02 - /control

data "oci_core_volume_backups" "instance_test_ebs_intl_db_VG02_backup" {
    compartment_id = data.terraform_remote_state.common_services.outputs.prod_services_compartment_id
    # volume_id      = 
    display_name   = "ocieipebsdb01_VG02_backup_20210216_212857"
}

module "instance_test_ebs_intl_db_VG02" {
  source              = "./modules/core_volume"
  tenancy_id          = var.tenancy_ocid
  volume_display_name = "ocieitebsdb_VG02"
  availability_domain = module.instance_test_ebs_intl_db.core_instance_ad[0]
  compartment_id      = module.instance_test_ebs_intl_db.core_instance_compartment[0]
  backup_policy       = "silver"
  size_in_gbs         = 50
  defined_tags        = local.tags["nprd_ebs_intl"]
  source_details = {
    source_id    = data.oci_core_volume_backups.instance_test_ebs_intl_db_VG02_backup.volume_backups.0.id
    source_type  = "volumeBackup" 
  }
}

resource "oci_core_volume_attachment" "instance_test_ebs_intl_db_VG02_attach" {
  instance_id     = module.instance_test_ebs_intl_db.core_instance_ids[0]
  volume_id       = module.instance_test_ebs_intl_db_VG02.core_volume_ids[0]
  device          = "/dev/oracleoci/oraclevdc"
  attachment_type = "paravirtualized"
}

############################################################################
# VG03 - /ora

# data "oci_core_volume_backups" "instance_test_ebs_intl_db_VG03_backup" {
#     compartment_id = data.terraform_remote_state.common_services.outputs.prod_services_compartment_id
#     volume_id      = 
#     display_name   = ""
# }

module "instance_test_ebs_intl_db_VG03" {
  source              = "./modules/core_volume"
  tenancy_id          = var.tenancy_ocid
  volume_display_name = "ocieitebsdb_VG03"
  availability_domain = module.instance_test_ebs_intl_db.core_instance_ad[0]
  compartment_id      = module.instance_test_ebs_intl_db.core_instance_compartment[0]
  backup_policy       = "silver"
  size_in_gbs         = 100
  defined_tags        = local.tags["nprd_ebs_intl"]
  # source_details = {
  #   source_id    = data.oci_core_volume_backups.instance_test_ebs_intl_db_VG03_backup.volume_backups.0.id
  #   source_type  = "volumeBackup" 
  # }
}

resource "oci_core_volume_attachment" "instance_test_ebs_intl_db_VG03_attach" {
  instance_id     = module.instance_test_ebs_intl_db.core_instance_ids[0]
  volume_id       = module.instance_test_ebs_intl_db_VG03.core_volume_ids[0]
  device          = "/dev/oracleoci/oraclevdd"
  attachment_type = "paravirtualized"
}

############################################################################
# VG04 - /redo

data "oci_core_volume_backups" "instance_test_ebs_intl_db_VG04_backup" {
    compartment_id = data.terraform_remote_state.common_services.outputs.prod_services_compartment_id
    # volume_id      = 
    display_name   = "ocieipebsdb01_VG04_backup_20210216_212857"
}

module "instance_test_ebs_intl_db_VG04" {
  source              = "./modules/core_volume"
  tenancy_id          = var.tenancy_ocid
  volume_display_name = "ocieitebsdb_VG04"
  availability_domain = module.instance_test_ebs_intl_db.core_instance_ad[0]
  compartment_id      = module.instance_test_ebs_intl_db.core_instance_compartment[0]
  backup_policy       = "silver"
  size_in_gbs         = 100
  defined_tags        = local.tags["nprd_ebs_intl"]
  source_details = {
    source_id    = data.oci_core_volume_backups.instance_test_ebs_intl_db_VG04_backup.volume_backups.0.id
    source_type  = "volumeBackup" 
  }
}

resource "oci_core_volume_attachment" "instance_test_ebs_intl_db_VG04_attach" {
  instance_id     = module.instance_test_ebs_intl_db.core_instance_ids[0]
  volume_id       = module.instance_test_ebs_intl_db_VG04.core_volume_ids[0]
  device          = "/dev/oracleoci/oraclevde"
  attachment_type = "paravirtualized"
}

############################################################################
# VG05 /data

data "oci_core_volume_backups" "instance_test_ebs_intl_db_VG05_backup" {
    compartment_id = data.terraform_remote_state.common_services.outputs.prod_services_compartment_id
    # volume_id      = 
    display_name   = "ocieipebsdb01_VG05_backup_20210216_212857"
}

module "instance_test_ebs_intl_db_VG05" {
  source              = "./modules/core_volume"
  tenancy_id          = var.tenancy_ocid
  volume_display_name = "ocieitebsdb_VG05"
  availability_domain = module.instance_test_ebs_intl_db.core_instance_ad[0]
  compartment_id      = module.instance_test_ebs_intl_db.core_instance_compartment[0]
  backup_policy       = "silver"
  size_in_gbs         = 7000
  defined_tags        = local.tags["nprd_ebs_intl"]
  source_details = {
    source_id    = data.oci_core_volume_backups.instance_test_ebs_intl_db_VG05_backup.volume_backups.0.id
    source_type  = "volumeBackup" 
  }
}

resource "oci_core_volume_attachment" "instance_test_ebs_intl_db_VG05_attach" {
  instance_id     = module.instance_test_ebs_intl_db.core_instance_ids[0]
  volume_id       = module.instance_test_ebs_intl_db_VG05.core_volume_ids[0]
  device          = "/dev/oracleoci/oraclevdf"
  attachment_type = "paravirtualized"
}

############################################################################
# VG06 /wood

# data "oci_core_volume_backups" "instance_test_ebs_intl_db_VG06_backup" {
#     compartment_id = data.terraform_remote_state.common_services.outputs.prod_services_compartment_id
#     # volume_id      = 
#     display_name   = "ocieipebsdb01_VG06_backup_20210216_212857"
# }

module "instance_test_ebs_intl_db_VG06" {
  source              = "./modules/core_volume"
  tenancy_id          = var.tenancy_ocid
  volume_display_name = "ocieitebsdb_VG06"
  availability_domain = module.instance_test_ebs_intl_db.core_instance_ad[0]
  compartment_id      = module.instance_test_ebs_intl_db.core_instance_compartment[0]
  backup_policy       = "silver"
  size_in_gbs         = 50
  defined_tags        = local.tags["nprd_ebs_intl"]
  # source_details = {
  #   source_id    = data.oci_core_volume_backups.instance_test_ebs_intl_db_VG06_backup.volume_backups.0.id
  #   source_type  = "volumeBackup" 
  # }
}

resource "oci_core_volume_attachment" "instance_test_ebs_intl_db_VG06_attach" {
  instance_id     = module.instance_test_ebs_intl_db.core_instance_ids[0]
  volume_id       = module.instance_test_ebs_intl_db_VG06.core_volume_ids[0]
  device          = "/dev/oracleoci/oraclevdg"
  attachment_type = "paravirtualized"
}

############################################################################