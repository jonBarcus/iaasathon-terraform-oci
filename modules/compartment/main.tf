resource "oci_identity_compartment" "compartment1" {
  name        = "test2-barcus-customer-migration"
  description = "compartment created by terraform"
}

data "oci_identity_compartments" "compartments1" {
  compartment_id = "${oci_identity_compartment.compartment1.compartment_id}"

  filter {
    name   = "name"
    values = ["test2-barcus-customer-migration"]
  }
}

output "compartment_id" {
  value = "${oci_identity_compartment.compartment1.id}"
}