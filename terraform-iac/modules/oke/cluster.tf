terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

resource "oci_containerengine_cluster" "this" {

  compartment_id = var.compartment_id

  name = var.cluster_name

  vcn_id = var.vcn_id

  kubernetes_version = var.kubernetes_version

  endpoint_config {
    is_public_ip_enabled = true

    subnet_id = var.endpoint_subnet_id
    nsg_ids   = [var.api_endpoint_nsg_id]
  }

  options {

    service_lb_subnet_ids = [
      var.load_balancer_subnet_id
    ]
  }

  type = "ENHANCED_CLUSTER"
}
