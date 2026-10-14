resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id

  cidr_blocks = [
    var.vcn_cidr
  ]

  display_name = "${var.environment}-vcn"

  dns_label = "devopsvcn"
}