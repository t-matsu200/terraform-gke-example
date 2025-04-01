# GKE クラスタを作成する VPC
resource "google_compute_network" "vpc_network" {
    project = var.common.project
    name                    = "vpc-${var.common.prefix}-${var.common.env}"
    auto_create_subnetworks = false    
}

# GKE クラスタを作成するサブネット
resource "google_compute_subnetwork" "subnet_asia_ne1" {
    project = var.common.project
    name          = "subnet-${var.common.prefix}-${var.common.env}"
    ip_cidr_range = var.vpc.subnet_cidr
    region        = var.common.region
    network       = google_compute_network.vpc_network.id
    private_ip_google_access = true

    secondary_ip_range {
        range_name    = "service-ranges-${var.common.prefix}-${var.common.env}"
        ip_cidr_range = var.vpc.secondary_ip_service_ranges
    }

    secondary_ip_range {
        range_name    = "pod-ranges-${var.common.prefix}-${var.common.env}"
        ip_cidr_range = var.vpc.secondary_ip_pod_ranges
    }
}
