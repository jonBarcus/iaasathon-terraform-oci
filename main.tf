# Configure the Oracle Cloud Infrastructure provider with an API Key
provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

# This runs a main.tf file in the /modules/compartment folder
# that creates a new compartment on the tenancy
module "create_compartment" {
  source = "./modules/compartment"
}

module "setup_networking" {
  subnet_count = 2 #how many subnets you want created
  source = "./modules/networking"
  created_compartment_id = "${module.create_compartment.compartment_id}"
  tenancy_ocid = "${var.tenancy_ocid}"
  availability_domains = "${data.oci_identity_availability_domains.ADs.availability_domains}"
}

module "object_storage" {
  source = "./modules/object_storage"
  created_compartment_id = "${module.create_compartment.compartment_id}"
  bucket_name = "test_barcus_bucket"
  # Name of the bucket that was created
  created_bucket_name = "${module.object_storage.created_bucket_name}"
  # name of the object being uploaded
  bucket_object_name = "test_customer_image"
  # location of the customer_image
  local_object_location = "../../../Downloads/test_customer_image"
  region = "${var.region}"
}

module "compute" {
  source = "./modules/compute"
  created_compartment_id = "${module.create_compartment.compartment_id}"
  # choose the name of the image you'd like
  name_of_image = "test_customer_image"
  # select launch mode (NATIVE, EMULATED, or CUSTOM)
  launch_mode = "NATIVE"
  # choose whether this is coming direct from BUCKET 'objectStorageTuple'
  # or from PUBLIC URI 'objectStorageUri'
  source_type = "objectStorageTuple"
  bucket_name = "${module.object_storage.created_bucket_name}"
  namespace_name = "${module.object_storage.namespace_name}"
  object_name = "${module.object_storage.created_object_name}"

  # instance_shape = "VM.Standard1.1"
  # # number of VM instances to be created
  # instance_count = 1
}


# Get a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
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

# created output for debugging

output "CREATED_IMAGE_ID" {
  value = "${module.compute.created_image_id}"
}

# output "available SHAPES" {
#   value = "${module.compute.available_shapes}"
# }

output created_object_name {
  value = "${module.object_storage.created_object_name}"
}

output created_bucket_name {
    value = "${module.object_storage.created_bucket_name}"
  # value = "${module.object_storage.buckets[0]}"
}

output "AVAILABILITY DOMAINS" {
  value = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain], "name")}"
}

output "compartment_id" {
  value = "${module.create_compartment.compartment_id}"
}

output "show-ads" {
  value = "${data.oci_identity_availability_domains.ADs.availability_domains}"
}

output "buckets" {
  value = "${data.oci_objectstorage_bucket_summaries.buckets1.bucket_summaries}"
}

output "this_tenancy" {
  value = "${data.oci_identity_tenancy.this_tenancy.name}"
}