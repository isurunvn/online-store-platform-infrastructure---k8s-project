output "vcn_id" {
  value = module.network.vcn_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}

output "endpoint_subnet_id" {
  value = module.network.endpoint_subnet_id
}

output "api_endpoint_nsg_id" {
  value = module.network.api_endpoint_nsg_id
}

output "workers_nsg_id" {
  value = module.network.workers_nsg_id
}

output "lb_nsg_id" {
  value = module.network.lb_nsg_id
}
