variable bucket_name {}

/*
 * This example shows how to manage a bucket
 */

resource "oci_objectstorage_bucket" "bucket" {
  compartment_id = "${var.created_compartment_id}"
  namespace      = "${data.oci_objectstorage_namespace.ns.namespace}"
  name           = "${var.bucket_name}"
  access_type    = "NoPublicAccess"
}

data "oci_objectstorage_bucket_summaries" "buckets" {
  compartment_id = "${var.created_compartment_id}"
  namespace      = "${data.oci_objectstorage_namespace.ns.namespace}"

  filter {
    name   = "name"
    values = ["${oci_objectstorage_bucket.bucket.name}"]
  }
}

output buckets {
  value = "${data.oci_objectstorage_bucket_summaries.buckets.bucket_summaries}"
}