provider "google" {
  credentials = file(var.GCP_CREDENTIALS_PATH)

  project = var.gcp_common.project
  region  = var.gcp_common.region
  zone    = var.gcp_common.zone
}

provider "google-beta" {
  credentials = file(var.GCP_CREDENTIALS_PATH)
  project     = var.gcp_common.project
  region      = var.gcp_common.region
  zone        = var.gcp_common.zone
}

provider "aws" {
  default_tags {
    tags = {
      "CreatedBy" = "terraform"
      "Name" = "t-matsuno"
    }
  }
}
