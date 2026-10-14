output "cluster_id" {
  value = oci_containerengine_cluster.this.id
}

output "cluster_name" {
  value = oci_containerengine_cluster.this.name
}

output "system_pool_id" {
  value = oci_containerengine_node_pool.system.id
}

output "application_pool_id" {
  value = oci_containerengine_node_pool.application.id
}