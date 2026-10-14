module "network" {
  source = "../../modules/network"

  compartment_id = var.compartment_id
  environment    = "prod"

  kubernetes_api_allowed_cidrs = var.kubernetes_api_allowed_cidrs

  vcn_cidr             = "10.20.0.0/16"
  public_subnet_cidr   = "10.20.10.0/24"
  private_subnet_cidr  = "10.20.20.0/24"
  endpoint_subnet_cidr = "10.20.30.0/24"
}

module "oke" {
  source = "../../modules/oke"

  compartment_id     = var.compartment_id
  cluster_name       = "devops-prod-cluster"
  kubernetes_version = "v1.36.4"

  vcn_id                  = module.network.vcn_id
  endpoint_subnet_id      = module.network.endpoint_subnet_id
  worker_subnet_id        = module.network.private_subnet_id
  load_balancer_subnet_id = module.network.public_subnet_id

  workers_nsg_id      = module.network.workers_nsg_id
  api_endpoint_nsg_id = module.network.api_endpoint_nsg_id

  system_pool_size      = 1
  application_pool_size = 2
  node_ocpus            = 1
  node_memory_gbs       = 6
}
