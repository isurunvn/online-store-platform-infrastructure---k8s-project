output "vcn_id" {
  value = oci_core_vcn.this.id
}

output "public_subnet_id" {
  value = oci_core_subnet.public.id
}

output "private_subnet_id" {
  value = oci_core_subnet.private.id
}

output "endpoint_subnet_id" {
  value = oci_core_subnet.endpoint.id
}

output "api_endpoint_nsg_id" {
  value = oci_core_network_security_group.api_endpoint.id
}

output "workers_nsg_id" {
  value = oci_core_network_security_group.workers.id
}

output "lb_nsg_id" {
  value = oci_core_network_security_group.lb.id
}
