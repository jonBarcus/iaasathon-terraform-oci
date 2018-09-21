#creating a security list
resource "oci_core_security_list" "security_list" {
 compartment_id = "${var.created_compartment_id}"
 vcn_id         = "${oci_core_virtual_network.vcn.id}"
 display_name   = "SecurityList"

 // allow outbound tcp traffic on all ports
 egress_security_rules {
   destination = "0.0.0.0/0"
   protocol    = "all"
 }

 // allow inbound ssh traffic from a specific port
 ingress_security_rules {
   protocol  = "6"         // tcp
   source    = "0.0.0.0/0"
   stateless = true

   tcp_options {
// these represent destination port range
     "min" = 22
     "max" = 22
   }
 }

// allow inbound http traffic from a specific port
 ingress_security_rules {
   protocol  = "6"         // tcp
   source    = "0.0.0.0/0"
   stateless = true

   tcp_options {
// these represent destination port range
     "min" = 80
     "max" = 80
   }
 }


 // allow inbound icmp traffic of a specific type
 ingress_security_rules {
   protocol  = "1"         // icmp
   source    = "0.0.0.0/0"
   stateless = true
 }
}

data "oci_core_security_lists" "created_security_lists" {

  compartment_id = "${var.created_compartment_id}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"

  filter {
    name = "id"
    values =["${oci_core_security_list.security_list.id}"]
  }

}

output "created_security_list" {

  value = "${oci_core_security_list.security_list.id}"
}

