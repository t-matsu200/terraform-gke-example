# 踏み台 VM
resource "google_compute_instance" "bastion" {
    project = var.common.project

    name         = "bastion-${var.common.prefix}-${var.common.env}"
    machine_type = var.bastion.machine_type
    zone         = var.common.zone

    tags = ["ssh"]  # ネットワークタグ
  
    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"  # OS イメージ
        }
    }

    network_interface {
        subnetwork_project = var.common.project
  
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
sudo apt install google-cloud-cli-gke-gcloud-auth-plugin
EOF

    scheduling {
        # 料金を抑えるためにプリエンプティブルにしておく
        preemptible = true
        # プリエンプティブルの場合は下のオプションが必須
        automatic_restart = false
    }
}

resource "google_compute_firewall" "ssh" {
    project = var.common.project

    name    = "vpc-${var.common.prefix}-${var.common.env}-ssh-allow"
    network = google_compute_network.vpc_network.name
    target_tags = ["ssh"]
    direction   = "INGRESS"

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = [
        var.bastion.ssh_sourcerange
    ]
}
