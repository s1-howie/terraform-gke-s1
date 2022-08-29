terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      #version >= "4.33.0" # -> 4.33.0 Aug 2022
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1" # -> 2.13.0 Aug 2022
    }
  }

  required_version = "> 0.14"
}

