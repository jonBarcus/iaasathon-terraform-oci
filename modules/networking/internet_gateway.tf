#Creating an internet gateway

resource "oci_core_internet_gateway" "gateway" {
  compartment_id = "${var.created_compartment_id}"
  display_name   = "TestInternetGateway"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
}