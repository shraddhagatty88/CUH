############################################################################
# OCI - Root Module - Main:
############################################################################
# IAM:

module "iam" {
  source             = "./modules/tf-oci-core-mod-iam" #"git::https://git.version1.com/scm/ivo/tf-oci-core-mod-iam.git"
  iam_compartments   = local.compartments
  iam_tag_namespaces = local.tag_namespaces
}

############################################################################
# VCN:
############################################################################

module "vcn" {
  source             = "./modules/tf-oci-core-mod-vcn" # "git::https://git.version1.com/scm/ivo/tf-oci-core-mod-vcn.git"
  vcn_inputs         = local.vcns
  #dhcp_options       = oci_core_dhcp_options.dhcp_options_gmp_dns.id
}

############################################################################
# VPN:
############################################################################

module "vpn" {
  source             = "./modules/tf-oci-mod-vpn" # "git::https://git.version1.com/scm/ivo/tf-oci-mod-vpn.git"
  vpn_inputs         = local.vpns
}

############################################################################
