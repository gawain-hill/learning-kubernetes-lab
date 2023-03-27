terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  #credentials = file("learning-kubernetes-381920-5202214c73e5.json")

  project = "learning-kubernetes-381920"
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

# Kubernetes control plane nodes

resource "google_compute_instance" "kubernetes_controller_0" {
  name           = "kubernetes-controller-0"
  machine_type   = "e2-small"
  can_ip_forward = true
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "200"
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.kubernetes.id
    network_ip = "10.240.0.10"
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
  tags = ["kubernetes", "controller"]
}

resource "google_compute_instance" "kubernetes_controller_1" {
  name           = "kubernetes-controller-1"
  machine_type   = "e2-small"
  can_ip_forward = true
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "200"
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.kubernetes.id
    network_ip = "10.240.0.11"
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
  tags = ["kubernetes", "controller"]
}

resource "google_compute_instance" "kubernetes_controller_2" {
  name           = "kubernetes-controller-2"
  machine_type   = "e2-small"
  can_ip_forward = true
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "200"
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.kubernetes.id
    network_ip = "10.240.0.12"
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
  tags = ["kubernetes", "controller"]
}

# Kubernetes worker nodes

resource "google_compute_instance" "kubernetes_worker_0" {
  name           = "kubernetes-worker-0"
  machine_type   = "e2-small"
  can_ip_forward = true
  metadata = {
    "pod-cidr" = "10.200.0.0/24"
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "200"
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.kubernetes.id
    network_ip = "10.240.0.20"
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
  tags = ["kubernetes", "worker"]
}

resource "google_compute_instance" "kubernetes_worker_1" {
  name         = "kubernetes-worker-1"
  machine_type = "e2-small"
  metadata = {
    "pod-cidr" = "10.200.1.0/24"
  }
  can_ip_forward = true
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "200"
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.kubernetes.id
    network_ip = "10.240.0.21"
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
  tags = ["kubernetes", "worker"]
}

resource "google_compute_instance" "kubernetes_worker_2" {
  name           = "kubernetes-worker-2"
  machine_type   = "e2-small"
  can_ip_forward = true
  metadata = {
    "pod-cidr" = "10.200.2.0/24"
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "200"
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.kubernetes.id
    network_ip = "10.240.0.22"
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
  tags = ["kubernetes", "worker"]
}