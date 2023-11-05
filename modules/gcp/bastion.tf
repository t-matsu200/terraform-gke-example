# 踏み台 VM
resource "google_compute_instance" "bastion" {
    project = var.gcp_common.project

    name         = "bastion-${var.gcp_common.prefix}-${var.gcp_common.env}"
    machine_type = var.gcp_bastion.machine_type
    zone         = var.gcp_common.zone

    tags = ["ssh"]  # ネットワークタグ
  
    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"  # OS イメージ
        }
    }

    network_interface {
        subnetwork_project = var.gcp_common.project
  
        network    = google_compute_network.vpc_network.name         # VPC
        subnetwork = google_compute_subnetwork.subnet_asia_ne1.name  # サブネット
  
        access_config {}  # パブリック IP を付与
    }

    metadata = {
        enable-oslogin = "true"  # OS Login を有効化
    }

    # 起動スクリプトで必要なツールと GKE のプラグインをインストール
    metadata_startup_script = <<EOF
#!/bin/bash
sudo apt update
sudo apt install kubectl unzip
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
sudo apt install google-cloud-sdk-gke-gcloud-auth-plugin
EOF

    scheduling {
        # 料金を抑えるためにプリエンプティブルにしておく
        preemptible = true
        # プリエンプティブルの場合は下のオプションが必須
        automatic_restart = false
    }
}

resource "google_compute_firewall" "ssh" {
    project = var.gcp_common.project

    name    = "vpc-${var.gcp_common.prefix}-${var.gcp_common.env}-ssh-allow"
    network = google_compute_network.vpc_network.name
    target_tags = ["ssh"]
    direction   = "INGRESS"

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = [
        var.gcp_bastion.ssh_sourcerange
    ]
}
