############################################################################
# Module Definition:
############################################################################
# Core Volume:

resource "oci_core_volume" "volume" {
  count = var.vol_count

  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.volume_display_name
  size_in_gbs         = var.size_in_gbs
  # kms_key_id          = "${var.kms_key_id}"
  defined_tags        = var.defined_tags
  
  dynamic "source_details" {
    for_each = var.source_details == null ? [] : list(var.source_details)
    content {
      id   = source_details.value.source_id
      type = source_details.value.source_type
    }
  }
  
  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"],
      defined_tags["Account.Created_By"],
      defined_tags["Account.Created_At"],
    ]
  }
}

############################################################################
# Core Volume Backup Policy:

data "oci_core_volume_backup_policies" "block_backup_policy" {
  filter {
    name   = "display_name"
    values = [var.backup_policy]
  }
}

resource "oci_core_volume_backup_policy_assignment" "volume_backup_policy_assignment" {
  count = var.vol_count

  asset_id  = element(oci_core_volume.volume.*.id, count.index)
  policy_id = data.oci_core_volume_backup_policies.block_backup_policy.volume_backup_policies[0]["id"]
}

############################################################################
