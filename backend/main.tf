variable "GCP_CREDENTIALS_PATH" {
  type        = string
  description = "Path for GCP credentials using env variables."
}

provider "google" {
  project = "t-matsuno-anthos-example-pj"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-c"
  credentials = file(var.GCP_CREDENTIALS_PATH)
}

resource "google_storage_bucket" "terraform-state-store" {
  name     = "tmatsuno-gke-test-tfstate"
  location = "us-west1"
  storage_class = "REGIONAL"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 5
    }
  }
}
