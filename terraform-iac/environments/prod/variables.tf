variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

variable "kubernetes_api_allowed_cidrs" {
  description = "Public CIDR blocks allowed to access the Kubernetes API endpoint on TCP/6443; use a /32 for a single laptop public IP."
  type        = set(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.kubernetes_api_allowed_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Each Kubernetes API allowed source must be a valid IPv4 or IPv6 CIDR block."
  }
}
