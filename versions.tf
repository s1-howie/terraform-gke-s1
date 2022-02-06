terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      #version = "3.52.0" # -> 4.9.0 Feb 2022
    }
  }

  required_version = "> 0.14"
}

