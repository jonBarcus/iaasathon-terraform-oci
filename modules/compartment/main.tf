resource "oci_identity_compartment" "compartment1" {
  name        = "test-barcus-customer-migration"
  description = "compartment created by terraform"
}

data "oci_identity_compartments" "compartments1" {
  compartment_id = "${oci_identity_compartment.compartment1.compartment_id}"

  filter {
    name   = "name"
    values = ["test-barcus-customer-migration"]
  }
}

output "compartments" {
  value = "${data.oci_identity_compartments.compartments1.compartments}"
}