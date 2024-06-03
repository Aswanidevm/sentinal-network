# Configure the GCP project and region
provider "google" {
  project = "jmc-devsecops"
  region  = "asia-south1"
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name = "my-vpc-network"
  auto_create_subnetworks = false
}

# Create a subnetwork with Sentinel enabled
resource "google_compute_subnetwork" "my-subnetwork" {
  name          = "my-subnetwork"
  ip_cidr_range = "10.0.0.0/16"
  region        = google_compute_network.vpc_network.region
  network       = google_compute_network.vpc_network.self_link
  enable_flow_logs = true
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

# Enable Sentinel for the subnetwork
resource "google_compute_network_endpoint_group" "sentinel_endpoint_group" {
  name    = "sentinel-endpoint-group"
  network = google_compute_network.vpc_network.self_link
  cloud_function {
    uri = "projects/jmc-devsecops/locations/us-central1/functions/sentinel-function"
  }
}

