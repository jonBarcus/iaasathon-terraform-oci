variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

# Defines the number of instances to deploy
variable "NumInstances" {
  default = "1"
}

# Defines the number of volumes to create and attach to each instance
# NOTE: Changing this value after applying it could result in re-attaching existing volumes to different instances.
# This is a result of using 'count' variables to specify the volume and instance IDs for the volume attachment resource.
variable "NumIscsiVolumesPerInstance" {
  default = "1"
}

variable "NumParavirtualizedVolumesPerInstance" {
  default = "1"
}

# Choose an Availability Domain
variable "availability_domain" {
  default = "1"
}

variable "instance_shape" {
  default = "VM.Standard1.1"
}

variable "instance_image_ocid" {
  type = "map"

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa2tq67tvbeavcmioghquci6p3pvqwbneq3vfy7fe7m7geiga4cnxa"
  }
}

variable "DBSize" {
  default = "50" // size in GBs
}

variable "BootStrapFile" {
  default = "./userdata/bootstrap"
}

variable "tag_namespace_description" {
  default = "Just a test"
}

variable "tag_namespace_name" {
  default = "exampletagns"
}