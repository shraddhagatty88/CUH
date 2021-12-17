############################################################################
# Module Output Values:
############################################################################
# Core Instance:

output "core_instance_ids" {
  value = oci_core_instance.instance.*.id
}

output "boot_volume_ids" {
  value = oci_core_instance.instance.*.boot_volume_id
}

output "core_instance_ad" {
  value = oci_core_instance.instance.*.availability_domain
}

output "core_instance_compartment" {
  value = oci_core_instance.instance.*.compartment_id
}

output "core_instance_public_ip" {
  value = oci_core_instance.instance.*.public_ip
}

output "core_instance_private_ip" {
  value = oci_core_instance.instance.*.private_ip
}

output "boot_volume_backup_policy_assignment_ids" {
  value = oci_core_volume_backup_policy_assignment.volume_backup_policy_assignment.*.id
}

############################################################################
