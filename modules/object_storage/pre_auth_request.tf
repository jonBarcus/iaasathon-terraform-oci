variable region {}

resource "oci_objectstorage_preauthrequest" "object-par" {
  namespace    = "${data.oci_objectstorage_namespace.ns.namespace}"
  bucket       = "${oci_objectstorage_bucket.bucket.name}"
  object       = "${oci_objectstorage_object.test_object.object}"
  name         = "image_creation"
  access_type  = "ObjectRead"                                       // ObjectRead, ObjectWrite, ObjectReadWrite, AnyObjectWrite
  time_expires = "2020-12-29T23:00:00Z"
}

output "par_request_url" {
  value = "https://objectstorage.${var.region}.oraclecloud.com${oci_objectstorage_preauthrequest.object-par.access_uri}"
}