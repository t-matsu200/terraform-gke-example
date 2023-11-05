module "gcp_modules" {
    source = "../../modules/gcp"

    # 変数を gcp_modules に渡す
    gcp_common  = var.gcp_common
    gcp_vpc     = var.gcp_vpc
    gcp_gke     = var.gcp_gke
    gcp_bastion = var.gcp_bastion
    GCP_CREDENTIALS_PATH = var.GCP_CREDENTIALS_PATH
}

# 全リソース作成後、GKE クラスタの接続コマンドを出力
output "command_to_connect_cluster" {
    value = "\n$ gcloud container clusters get-credentials ${module.gcp_modules.cluster_name} --region ${module.gcp_modules.cluster_location} --project ${module.gcp_modules.cluster_project}\n"
}
