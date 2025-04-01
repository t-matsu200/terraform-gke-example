variable "GC_CREDENTIALS_PATH" {
  type        = string
  description = "Path for GCP credentials using env variables."
}

variable "common" {
    type = object ({
        prefix  = string  # 固有のプレフィクス (任意の文字列)
        env     = string  # 環境名 ( dev、prod など)
        project = string  # プロジェクト
        region  = string  # リージョン
        zone    = string  # ゾーン
        email   = string  # GCP ServiceAccount のメールアドレス
    })
    description = "リソース共通の設定値"
}

variable "vpc" {
    type = object ({
        subnet_cidr = string  # サブネットの CIDR 範囲 ( GKE ノード、踏み台ホストが使用する IP 範囲)
        secondary_ip_service_ranges = string # GKE Service が使用する IP 範囲
        secondary_ip_pod_ranges = string # GKE Pod が使用する IP 範囲
    })
    description = "VPC の設定値"
}

variable "gke" {
    type = object ({
        master_cidr  = string  # コントロールプレーンが使用する IP 範囲
        preemptible  = bool    # プリエンプティブル VM インスタンスを利用するか否か
    })
    description = "GKE の設定値"
}

variable "bastion" {
    type = object ({
        machine_type    = string  # 踏み台 VM のマシンタイプ
        ssh_sourcerange = string  # 踏み台 VM に SSH アクセスできるソース IP 範囲
    })
    description = "踏み台 VM の設定値"
}
