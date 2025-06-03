output "gke_name" {
  value = google_container_cluster.gke_cluster.name
}

output "cloudsql_ip" {
  value = google_sql_database_instance.mysql.public_ip_address
}
