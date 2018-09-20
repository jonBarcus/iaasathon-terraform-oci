variable "created_compartment_id" {}

# This is creating a VCN with a CIDR block of
# 10.0.0.0/16

resource "oci_core_virtual_network" "vcn" {
  cidr_block     = "10.0.0.0/16"
  dns_label      = "vcn1"
  compartment_id = "${var.created_compartment_id}"
  display_name   = "test-barcus-customer-vcn1"
}

# output "VCN_NAME" {
#   value = "${oci_core_virtual_network.vcn.vcn_name}"
# }