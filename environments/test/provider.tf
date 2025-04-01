provider "google" {
  credentials = file(var.GC_CREDENTIALS_PATH)

  project = var.common.project
  region  = var.common.region
  zone    = var.common.zone
}

# provider "google-beta" {
#   credentials = file(var.GC_CREDENTIALS_PATH)
#   project     = var.common.project
#   region      = var.common.region
#   zone        = var.common.zone
# }
