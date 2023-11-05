resource "google_container_cluster" "primary" {
    project          = var.gcp_common.project
    name             = "cluster-${var.gcp_common.prefix}-${var.gcp_common.env}"
    location         = var.gcp_common.region
    network          = google_compute_network.vpc_network.id
    subnetwork       = google_compute_subnetwork.subnet_asia_ne1.id
    deletion_protection      = false
    initial_node_count       = 1
    min_master_version       = "1.27.4-gke.900"
    networking_mode          = "VPC_NATIVE"
    remove_default_node_pool = true
    enable_l4_ilb_subsetting = true

    ip_allocation_policy {
        cluster_secondary_range_name  = "pod-ranges-${var.gcp_common.prefix}-${var.gcp_common.env}"
        services_secondary_range_name = "service-ranges-${var.gcp_common.prefix}-${var.gcp_common.env}"
    }

    release_channel {
      channel = "STABLE"
    }

    # 限定公開クラスタの設定
    private_cluster_config {
        enable_private_nodes    = true
        enable_private_endpoint = true
        master_ipv4_cidr_block  = var.gcp_gke.master_cidr
        master_global_access_config {
          enabled = false
        }
    }

    master_authorized_networks_config {
        # コントロールプレーンへのアクセスを許可する IP 範囲
        cidr_blocks {
            cidr_block = var.gcp_vpc.subnet_cidr  # ノードと踏み台が作られるサブネットからのアクセスを許可
        }
    }

    maintenance_policy {
      recurring_window {
        start_time = "2023-11-01T00:00:00Z"
        end_time   = "2023-11-01T04:00:00Z"
        recurrence = "FREQ=WEEKLY;BYDAY=FR,SA,SU"
      }
    }

    timeouts {
      create = "60m"
      update = "60m"
      delete = "2h"
    }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "node-pool-${var.gcp_common.prefix}-${var.gcp_common.env}"
  location   = var.gcp_common.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  upgrade_settings {
    max_surge       = 1   
    max_unavailable = 0
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = var.gcp_gke.preemptible
    machine_type = "e2-medium"
    disk_size_gb = 20
    service_account = "t-matsuno-terraform-account@${var.gcp_common.project}.iam.gserviceaccount.com"
    tags            = ["gke-node", "${var.gcp_common.project}-gke"]
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.gcp_common.env
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "2h"
  }
}
