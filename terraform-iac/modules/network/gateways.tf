resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id

  vcn_id = oci_core_vcn.this.id

  display_name = "${var.environment}-igw"

  enabled = true
}

resource "oci_core_nat_gateway" "this" {
  compartment_id = var.compartment_id

  vcn_id = oci_core_vcn.this.id

  display_name = "${var.environment}-nat"
}

data "oci_core_services" "all_services" {
}

resource "oci_core_service_gateway" "this" {
  compartment_id = var.compartment_id

  vcn_id = oci_core_vcn.this.id

  display_name = "${var.environment}-sgw"

  services {
    service_id = data.oci_core_services.all_services.services[0].id
  }
}