module "gke_modules" {
    source = "../../modules/gke"

    # 変数を gke_modules に渡す
    common  = var.common
    vpc     = var.vpc
    gke     = var.gke
    bastion = var.bastion
}

# 全リソース作成後、GKE クラスタの接続コマンドを出力
output "command_to_connect_cluster" {
    value = "\n$ gcloud container clusters get-credentials ${module.gke_modules.cluster_name} --region ${module.gke_modules.cluster_location} --project ${module.gke_modules.cluster_project}\n"
}
