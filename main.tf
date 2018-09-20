# Configure the Oracle Cloud Infrastructure provider with an API Key
provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

module "create_compartment" {
  source = "./modules/compartment"
}

# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.compartment_ocid}"
}

# Get info about the tenancy
data "oci_identity_tenancy" "this_tenancy" {
  tenancy_id = "${var.tenancy_ocid}"
  # name = "${tenancy_id["name"]}"

  # bucket_namespace = "$${tenancy_id["name"]}"
  # filter {
  #   name = "name"
  #   bucket_namespace = ["${oci_identity_tenancy.this_tenancy.name}"]
  # }
}

data "oci_objectstorage_bucket_summaries" "buckets1" {
  compartment_id = "${var.compartment_ocid}"
  namespace = "${data.oci_identity_tenancy.this_tenancy.name}"

  # filter {
  #   name = "name"
  #   values = ["${oci_objectstorage_bucket.bucket1.name}"]
  # }
}

# Output the result
output "show-ads" {
  value = "${data.oci_identity_availability_domains.ads.availability_domains}"
}

output "buckets" {
  value = "${data.oci_objectstorage_bucket_summaries.buckets1.bucket_summaries}"
}

output "this_tenancy" {
  value = "${data.oci_identity_tenancy.this_tenancy.name}"
}