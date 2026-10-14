resource "oci_core_subnet" "public" {
  compartment_id = var.compartment_id

  vcn_id = oci_core_vcn.this.id

  cidr_block = var.public_subnet_cidr

  display_name = "${var.environment}-public-subnet"

  route_table_id = oci_core_route_table.public.id

  prohibit_public_ip_on_vnic = false

  dns_label = "public"
}

resource "oci_core_subnet" "private" {
  compartment_id = var.compartment_id

  vcn_id = oci_core_vcn.this.id

  cidr_block = var.private_subnet_cidr

  display_name = "${var.environment}-private-subnet"

  route_table_id = oci_core_route_table.private.id

  prohibit_public_ip_on_vnic = true

  dns_label = "private"
}

resource "oci_core_subnet" "endpoint" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  cidr_block     = var.endpoint_subnet_cidr

  display_name               = "${var.environment}-oke-endpoint-subnet"
  route_table_id             = oci_core_route_table.public.id
  prohibit_public_ip_on_vnic = false
  dns_label                  = "okeapi"
}