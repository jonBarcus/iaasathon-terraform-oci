variable subnet_count {}
# variable created_compartment_id {}
variable tenancy_ocid {}
variable availability_domains {type = "list"}
variable security_list_ids {}
variable created_route_table {}

resource "oci_core_subnet" "test-subnet" {
  count = "${var.subnet_count}"
  # trying to get it iterate through the different AD domains
  # ad_count = count - (count + 1)
  # availability_domain = "${lookup(var.availability_domains[var.availability_domain - "${var.subnet_count}"],"name")}"
  availability_domain = "${lookup(var.availability_domains[count.index],"name")}"
  # ORIGINAL availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  cidr_block          = "10.0.${1 + count.index}.0/24"
  display_name        = "Test Barcus Subnet ${count.index}"
  dns_label           = "tbarcussub${1 + count.index}"
  compartment_id      = "${var.created_compartment_id}"
  vcn_id              = "${oci_core_virtual_network.vcn.id}"
  security_list_ids   = ["${var.security_list_ids}"]
  route_table_id      = "${var.created_route_table}"
  dhcp_options_id     = "${oci_core_virtual_network.vcn.default_dhcp_options_id}"
}

data "oci_core_subnets" "test_subnets" {
  #Required
  compartment_id = "${var.created_compartment_id}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

output "created_subnets" {

  value = "${data.oci_core_subnets.test_subnets.subnets}"
}