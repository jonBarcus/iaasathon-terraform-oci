variable local_object_location {}
variable bucket_object_name {}
variable created_bucket_name {}

resource "oci_objectstorage_object" "test_object" {
	#Required
	bucket = "${var.created_bucket_name}"
	# content = "${var.object_content}"
	# content and source are mutually exclusive it seems...
	# https://github.com/terraform-providers/terraform-provider-oci/blob/master/docs/object_storage/objects.md
	source = "${var.local_object_location}"
	# namespace = "${var.object_namespace}"
	# figure out better way to do the namespace
	namespace = "${data.oci_objectstorage_namespace.ns.namespace}"
	object = "${var.bucket_object_name}"

	#Optional
# 	content_encoding = "${var.object_content_encoding}"
# 	content_language = "${var.object_content_language}"
# 	content_type = "${var.object_content_type}"
# 	metadata = "${var.object_metadata}"
	}

	data "oci_objectstorage_object_head" "test_object_head" {
		#Required
		bucket = "${var.created_bucket_name}"
		namespace = "${data.oci_objectstorage_namespace.ns.namespace}"
		object = "${var.bucket_object_name}"
	}

	output "created_object_name" {
		value = "${data.oci_objectstorage_object_head.test_object_head.object}"
	}