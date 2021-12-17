resource "oci_core_instance" "access_instance_linux" {
  availability_domain  = var.instance_availability_domain
  compartment_id       = var.common_services_compartment
  display_name         = var.instance_name
  shape                = "VM.Standard.E3.Flex"
  shape_config {
    memory_in_gbs = 16
    ocpus         = 2
  }
  create_vnic_details {
    subnet_id          = var.dmz_subnet
    display_name       = var.instance_name
    hostname_label     = var.instance_name
    private_ip         = var.private_ip
    assign_public_ip   = true
    nsg_ids            = var.network_sec_groups
  }
  fault_domain   = var.fault_domain
  source_details {
    source_id               = "ocid1.image.oc1.uk-london-1.aaaaaaaas573xrwpqk5wu3pwopls7t43remq75bgxijddnlcs6voow6w4wdq"
    source_type             = "image"
  }
  lifecycle {
    ignore_changes = [
      state,
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"],
      defined_tags["Account.Created_By"],
      defined_tags["Account.Created_At"],
    ]
  }
}

resource "oci_core_volume_backup_policy_assignment" "_boot_volume_backup" {
    asset_id = oci_core_instance.access_instance.boot_volume_id
    policy_id = "ocid1.volumebackuppolicy.oc1..aaaaaaaagcremuefit7dpcnjpdrtphjk4bwm3emm55t6cghctt2m6iyyjdva"
}
