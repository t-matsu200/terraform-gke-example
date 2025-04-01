terraform {
  backend "gcs" {
    # tfstate ファイルの保存先となる GCS バケット
    bucket = "tmatsuno-gke-test-tfstate"
    prefix = "tterraform-gke-example"
  }
}
