############################################################################
# OCI - Core Module - VCN - Outputs:
############################################################################

############################################################################
# VCN:
############################################################################

output "vcns" {
  value = {
    for vcn in oci_core_vcn.vcn:
      vcn.display_name => vcn.id
  }
}

output "drgs" {
  value = {
    for drg in oci_core_drg.drg:
      drg.display_name => drg.id
  }
}

output "subnets" {
  value = {
    for subnet in oci_core_subnet.subnet:
      subnet.display_name => subnet.id
  }
}

############################################################################
