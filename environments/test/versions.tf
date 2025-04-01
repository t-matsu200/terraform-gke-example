terraform {
  required_version = "~> 1.11.0"

  required_providers {
    # http = {
    #   source  = "hashicorp/http"
    #   version = "~> 3.4"
    # }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.27"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.27"
    }
  }
}
