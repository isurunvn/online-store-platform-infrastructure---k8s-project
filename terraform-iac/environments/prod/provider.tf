terraform {
  required_version = ">= 1.12"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.20"
    }
  }
}

provider "oci" {
  config_file_profile = "DEFAULT"
}