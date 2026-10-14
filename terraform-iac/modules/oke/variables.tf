variable "compartment_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "vcn_id" {
  type = string
}

variable "workers_nsg_id" {
  type = string
}

variable "api_endpoint_nsg_id" {
  type = string
}

variable "system_pool_size" {
  type    = number
  default = 1
}

variable "application_pool_size" {
  type    = number
  default = 2
}

variable "node_shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "node_ocpus" {
  type    = number
  default = 1
}

variable "node_memory_gbs" {
  type    = number
  default = 6
}

variable "endpoint_subnet_id" {
  type = string
}

variable "worker_subnet_id" {
  type = string
}

variable "load_balancer_subnet_id" {
  type = string
}
