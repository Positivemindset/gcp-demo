terraform {
  required_version = ">= 0.11.1"
}

variable "gcp_credentials" {
  description = "GCP credentials needed by google provider"
}

variable "gcp_project" {
  description = "GCP project name"
}

variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
  default     = "eu-west-1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. us-east1-a"
  default     = "eu-west1-b"
}

variable "machine_type" {
  description = "GCP machine type"
  default     = "n1-standard-2"
}

variable "instance_name" {
  description = "GCP instance name"
  default     = "GCP sentinel Demo"
}

variable "image" {
  description = "image to build instance from"
  default     = "debian-cloud/debian-9"
}

provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project
  region      = var.gcp_region
}

resource "google_compute_instance" "demo" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.gcp_zone
  labels = {
    name   = "demo"
    ttl   = "8h"
    owner = "Harsha Evuri"
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

output "external_ip" {
  value = google_compute_instance.demo.network_interface[0].access_config[0].nat_ip
}

