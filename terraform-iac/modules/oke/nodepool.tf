data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_containerengine_node_pool" "system" {

  cluster_id     = oci_containerengine_cluster.this.id
  compartment_id = var.compartment_id

  name = "system-pool"

  kubernetes_version = var.kubernetes_version

  node_shape = var.node_shape

  node_shape_config {
    ocpus         = var.node_ocpus
    memory_in_gbs = var.node_memory_gbs
  }

  node_source_details {
    image_id    = "ocid1.image.oc1.phx.aaaaaaaapmc6ysehijcuphgcnyfyfa7kpv2im43mhcitnefl7stk22tyowdq"
    source_type = "IMAGE"
  }

  node_config_details {

    size = var.system_pool_size

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.worker_subnet_id
    }

    nsg_ids = [
      var.workers_nsg_id
    ]
  }

  initial_node_labels {
    key   = "workload"
    value = "system"
  }
}

resource "oci_containerengine_node_pool" "application" {

  cluster_id     = oci_containerengine_cluster.this.id
  compartment_id = var.compartment_id

  name = "application-pool"

  kubernetes_version = var.kubernetes_version

  node_shape = var.node_shape

  node_shape_config {
    ocpus         = var.node_ocpus
    memory_in_gbs = var.node_memory_gbs
  }

  node_source_details {
    image_id    = "ocid1.image.oc1.phx.aaaaaaaapmc6ysehijcuphgcnyfyfa7kpv2im43mhcitnefl7stk22tyowdq"
    source_type = "IMAGE"
  }

  node_config_details {

    size = var.application_pool_size

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.worker_subnet_id
    }

    nsg_ids = [
      var.workers_nsg_id
    ]
  }

  initial_node_labels {
    key   = "workload"
    value = "application"
  }
}
