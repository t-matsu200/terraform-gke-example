# Cloud Router
resource "google_compute_router" "router" {
    project = var.gcp_common.project

    name    = "router-${var.gcp_common.prefix}-${var.gcp_common.env}"
    region  = var.gcp_common.region
    network = google_compute_network.vpc_network.id
}

# Cloud NAT
resource "google_compute_router_nat" "nat" {
    project = var.gcp_common.project

    name = "nat-${var.gcp_common.prefix}-${var.gcp_common.env}"
    router                 = google_compute_router.router.name
    region                 = google_compute_router.router.region
    nat_ip_allocate_option = "AUTO_ONLY"

    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

    log_config {
        enable = true
        filter = "ERRORS_ONLY"
    }
}
