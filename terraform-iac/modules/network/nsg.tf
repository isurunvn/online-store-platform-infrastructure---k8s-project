resource "oci_core_network_security_group" "workers" {
  compartment_id = var.compartment_id

  vcn_id = oci_core_vcn.this.id

  display_name = "${var.environment}-workers-nsg"
}

resource "oci_core_network_security_group" "api_endpoint" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name = "${var.environment}-oke-api-endpoint-nsg"
}

# Required worker-to-control-plane communication.
resource "oci_core_network_security_group_security_rule" "api_from_workers_6443" {
  network_security_group_id = oci_core_network_security_group.api_endpoint.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.private_subnet_cidr
  source_type               = "CIDR_BLOCK"
  description               = "Allow workers to reach the Kubernetes API"

  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "api_from_workers_12250" {
  network_security_group_id = oci_core_network_security_group.api_endpoint.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.private_subnet_cidr
  source_type               = "CIDR_BLOCK"
  description               = "Allow workers to reach the Kubernetes control plane"

  tcp_options {
    destination_port_range {
      min = 12250
      max = 12250
    }
  }
}

resource "oci_core_network_security_group_security_rule" "api_from_workers_path_mtu" {
  network_security_group_id = oci_core_network_security_group.api_endpoint.id
  direction                 = "INGRESS"
  protocol                  = "1"
  source                    = var.private_subnet_cidr
  source_type               = "CIDR_BLOCK"
  description               = "Allow worker path MTU discovery"

  icmp_options {
    type = 3
    code = 4
  }
}

# Public API access is deliberately limited to caller-provided CIDRs.
resource "oci_core_network_security_group_security_rule" "api_from_administrators" {
  for_each = var.kubernetes_api_allowed_cidrs

  network_security_group_id = oci_core_network_security_group.api_endpoint.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = each.value
  source_type               = "CIDR_BLOCK"
  description               = "Allow trusted administrator access to the Kubernetes API"

  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "api_to_workers" {
  network_security_group_id = oci_core_network_security_group.api_endpoint.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = var.private_subnet_cidr
  destination_type          = "CIDR_BLOCK"
  description               = "Allow control-plane communication to workers"
}

resource "oci_core_network_security_group_security_rule" "api_to_workers_path_mtu" {
  network_security_group_id = oci_core_network_security_group.api_endpoint.id
  direction                 = "EGRESS"
  protocol                  = "1"
  destination               = var.private_subnet_cidr
  destination_type          = "CIDR_BLOCK"
  description               = "Allow control-plane path MTU discovery"

  icmp_options {
    type = 3
    code = 4
  }
}

resource "oci_core_network_security_group_security_rule" "api_to_oracle_services" {
  network_security_group_id = oci_core_network_security_group.api_endpoint.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = data.oci_core_services.all_services.services[0].cidr_block
  destination_type          = "SERVICE_CIDR_BLOCK"
  description               = "Allow the control plane to communicate with OKE"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

# Required worker-node communication and OKE bootstrap connectivity.
resource "oci_core_network_security_group_security_rule" "workers_from_workers" {
  network_security_group_id = oci_core_network_security_group.workers.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = var.private_subnet_cidr
  source_type               = "CIDR_BLOCK"
  description               = "Allow worker-to-worker and pod-to-pod communication"
}

resource "oci_core_network_security_group_security_rule" "workers_from_api" {
  network_security_group_id = oci_core_network_security_group.workers.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.endpoint_subnet_cidr
  source_type               = "CIDR_BLOCK"
  description               = "Allow Kubernetes control-plane communication to workers"
}

resource "oci_core_network_security_group_security_rule" "workers_from_api_path_mtu" {
  network_security_group_id = oci_core_network_security_group.workers.id
  direction                 = "INGRESS"
  protocol                  = "1"
  source                    = var.endpoint_subnet_cidr
  source_type               = "CIDR_BLOCK"
  description               = "Allow control-plane path MTU discovery"

  icmp_options {
    type = 3
    code = 4
  }
}

resource "oci_core_network_security_group_security_rule" "workers_to_workers" {
  network_security_group_id = oci_core_network_security_group.workers.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = var.private_subnet_cidr
  destination_type          = "CIDR_BLOCK"
  description               = "Allow worker-to-worker and pod-to-pod communication"
}

resource "oci_core_network_security_group_security_rule" "workers_to_api_6443" {
  network_security_group_id = oci_core_network_security_group.workers.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = var.endpoint_subnet_cidr
  destination_type          = "CIDR_BLOCK"
  description               = "Allow workers to reach the Kubernetes API"

  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "workers_to_api_12250" {
  network_security_group_id = oci_core_network_security_group.workers.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = var.endpoint_subnet_cidr
  destination_type          = "CIDR_BLOCK"
  description               = "Allow workers to reach the Kubernetes control plane"

  tcp_options {
    destination_port_range {
      min = 12250
      max = 12250
    }
  }
}

resource "oci_core_network_security_group_security_rule" "workers_to_api_path_mtu" {
  network_security_group_id = oci_core_network_security_group.workers.id
  direction                 = "EGRESS"
  protocol                  = "1"
  destination               = var.endpoint_subnet_cidr
  destination_type          = "CIDR_BLOCK"
  description               = "Allow worker path MTU discovery"

  icmp_options {
    type = 3
    code = 4
  }
}

resource "oci_core_network_security_group_security_rule" "workers_to_oracle_services" {
  network_security_group_id = oci_core_network_security_group.workers.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = data.oci_core_services.all_services.services[0].cidr_block
  destination_type          = "SERVICE_CIDR_BLOCK"
  description               = "Allow workers to communicate with OCI services"
}

resource "oci_core_network_security_group" "lb" {
  compartment_id = var.compartment_id

  vcn_id = oci_core_vcn.this.id

  display_name = "${var.environment}-lb-nsg"
}
