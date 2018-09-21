variable instance_shape {}
variable instance_count {}
variable created_image_id {}
variable authorized_keys {}
variable availability_domain { type = "string" }
variable available_subnet {}
# variable BootStrapFile {}

resource "oci_core_instance" "TFInstance" {
  count               = "${var.instance_count}"
  availability_domain = "${var.availability_domain}"
  compartment_id      = "${var.created_compartment_id}"
  display_name        = "Test_Instance${count.index}"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${var.available_subnet}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "testinstance${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.created_image_id}"

    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true

  metadata {
    ssh_authorized_keys = "${var.authorized_keys}"
    # user_data           = "${base64encode(file(var.BootStrapFile))}"
  }
  # defined_tags = "${
  #   map(
  #     "${oci_identity_tag_namespace.tag-namespace1.name}.${oci_identity_tag.tag2.name}", "awesome-app-server"
  #   )
  # }"
  # freeform_tags = "${map("freeformkey${count.index}", "freeformvalue${count.index}")}"
  timeouts {
    create = "60m"
  }
}

# data "oci_core_shapes" "test_shapes" {
#     #Required
#     compartment_id = "${var.created_compartment_id}"

#     #Optional
#     # availability_domain = "${var.shape_availability_domain}"
#     # image_id = "${oci_core_image.test_image.id}"
# }

# output "available_shapes" {

#   value = "${data.oci_core_shapes.test_shapes.shapes}"
# }