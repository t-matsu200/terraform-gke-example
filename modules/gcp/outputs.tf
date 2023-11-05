output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_location" {
    value = google_container_cluster.primary.location
}

output "cluster_project" {
    value = google_container_cluster.primary.project
}
