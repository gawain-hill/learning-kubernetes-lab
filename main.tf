terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = "{{YOUR GCP PROJECT}}"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}


resource "google_compute_network" "kubernetes_lab" {
  name                    = "kubernetes-lab"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kubernetes" {
  name          = "kubernetes"
  network       = google_compute_network.kubernetes_lab.id
  ip_cidr_range = "10.240.0.0/24"
}

resource "google_compute_firewall" "internal_rules" {
  name    = "internal-rules"
  network = google_compute_network.kubernetes_lab.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = [
    "10.240.0.0/24",
    "10.200.0.0/16"
  ]
}

resource "google_compute_firewall" "external_rules" {
  name    = "external-rules"
  network = google_compute_network.kubernetes_lab.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]
}

resource "google_compute_address" "public" {
  name = "kubernetes-lab-public-address"
}

resource "google_compute_instance" "kubernetes_controller" {
  count          = 3
  name           = "kubernetes-controller-${count.index}"
  machine_type   = "e2-small"
  can_ip_forward = true
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/	ubuntu-2204-lts"
      size  = "200"
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.kubernetes.id
    network_ip = "10.240.0.1${count.index}"
    access_config {}
  }
  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring"
    ]
  }
  tags = ["kubernetes-lab", "kubernetes", "controller"]
}

resource "google_compute_instance" "kubernetes_worker" {
  count          = 3
  name           = "kubernetes-worker-${count.index}"
  machine_type   = "e2-small"
  can_ip_forward = true
  metadata = {
    "pod-cidr" = "10.200.${count.index}.0/24"
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts "
      size  = "200"
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.kubernetes.id
    network_ip = "10.240.0.2${count.index}"
    access_config {}
  }
  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring"
    ]
  }
  tags = ["kubernetes-lab", "kubernetes", "worker"]
}
