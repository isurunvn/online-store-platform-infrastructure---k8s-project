variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vcn_cidr" {
  description = "VCN CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
}

variable "endpoint_subnet_cidr" {
  description = "Public subnet CIDR for the Kubernetes API endpoint"
  type        = string
}

variable "kubernetes_api_allowed_cidrs" {
  description = "Public CIDR blocks allowed to access the Kubernetes API endpoint on TCP/6443"
  type        = set(string)
  default     = []
}
