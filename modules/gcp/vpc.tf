# GKE クラスタを作成する VPC
resource "google_compute_network" "vpc_network" {
    project = var.gcp_common.project
    name                    = "vpc-${var.gcp_common.prefix}-${var.gcp_common.env}"
    auto_create_subnetworks = false    
}

# GKE クラスタを作成するサブネット
resource "google_compute_subnetwork" "subnet_asia_ne1" {
    project = var.gcp_common.project
  
    name          = "subnet-${var.gcp_common.prefix}-${var.gcp_common.env}"
    ip_cidr_range = var.gcp_vpc.subnet_cidr
    region        = var.gcp_common.region
    network       = google_compute_network.vpc_network.id
    
    private_ip_google_access = true

    secondary_ip_range {
        range_name    = "service-ranges-${var.gcp_common.prefix}-${var.gcp_common.env}"
        ip_cidr_range = var.gcp_vpc.secondary_ip_service_ranges
    }

    secondary_ip_range {
        range_name    = "pod-ranges-${var.gcp_common.prefix}-${var.gcp_common.env}"
        ip_cidr_range = var.gcp_vpc.secondary_ip_pod_ranges
    }
}
