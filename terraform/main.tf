provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = var.network_name
}

resource "google_compute_subnetwork" "subnet" {
  name          = "multi-tier-subnet"
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.vpc_network.id
  region        = var.region
}

resource "google_container_cluster" "gke_cluster" {
  name     = "multi-tier-gke"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name

  ip_allocation_policy {}
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.gke_cluster.name

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  initial_node_count = 2
  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }
}


resource "google_sql_database_instance" "mysql" {
  name             = "multi-tier-db"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = true
      authorized_networks {
        name  = "allow-all"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_user" "users" {
  name     = "admin"
  instance = google_sql_database_instance.mysql.name
  password = "YourSecurePassword123"
}
