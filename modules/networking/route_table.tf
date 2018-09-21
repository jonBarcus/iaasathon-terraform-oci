#creating route table and entry
resource "oci_core_route_table" "route_table" {
 compartment_id = "${var.created_compartment_id}"
 vcn_id         = "${oci_core_virtual_network.vcn.id}"
 display_name   = "RouteTable"

 route_rules {
   cidr_block        = "0.0.0.0/0"
   network_entity_id = "${oci_core_internet_gateway.gateway.id}"
 }

}

data "oci_core_route_tables" "created_route_tables" {

  compartment_id = "${var.created_compartment_id}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"

  filter {
    name = "id"
    values =["${oci_core_route_table.route_table.id}"]
  }

}

output "created_route_tables" {

  value = "${oci_core_route_table.route_table.id}"
}