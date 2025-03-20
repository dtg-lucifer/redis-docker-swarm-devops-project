# VPC Network
resource "google_compute_network" "swarm_network" {
  name                    = "${var.project_prefix}-network"
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "VPC Network for Docker Swarm Cluster"
}

# Subnet
resource "google_compute_subnetwork" "swarm_subnet" {
  name          = "${var.project_prefix}-subnet"
  project       = var.project_id
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.swarm_network.id
}

# Firewall Rules
# Allow SSH from anywhere
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.project_prefix}-allow-ssh"
  network = google_compute_network.swarm_network.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["swarm-node"]
}

# Allow HTTP/HTTPS from anywhere
resource "google_compute_firewall" "allow_http" {
  name    = "${var.project_prefix}-allow-http"
  network = google_compute_network.swarm_network.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["swarm-node"]
}

# Allow all internal traffic between swarm nodes
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.project_prefix}-allow-internal"
  network = google_compute_network.swarm_network.name
  project = var.project_id

  allow {
    protocol = "all"
  }

  source_tags = ["swarm-node"]
  target_tags = ["swarm-node"]
}

# Allow specific Docker Swarm ports
resource "google_compute_firewall" "allow_swarm" {
  name    = "${var.project_prefix}-allow-swarm"
  network = google_compute_network.swarm_network.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["2377", "7946", "6379", "6380", "5001"]
  }

  allow {
    protocol = "udp"
    ports    = ["7946", "4789"]
  }

  source_tags = ["swarm-node"]
  target_tags = ["swarm-node"]
}

# Compute Instances
resource "google_compute_instance" "swarm_manager" {
  name         = "${var.project_prefix}-manager"
  project      = var.project_id
  machine_type = var.machine_type
  zone         = "${var.region}-a"
  tags         = ["swarm-node", "swarm-manager"]

  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = var.disk_size_gb
    }
  }

  network_interface {
    network    = google_compute_network.swarm_network.id
    subnetwork = google_compute_subnetwork.swarm_subnet.id
    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    startup-script = "${file("${path.module}/scripts/startup.sh")}"
    ssh-keys       = "${var.ssh_user}:${file("${path.module}/keys/id_rsa.pub")} ${var.ssh_user}:${file("/home/piush/.ssh/id_rsa.pub")}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "swarm_worker" {
  name         = "${var.project_prefix}-worker"
  project      = var.project_id
  machine_type = var.machine_type
  zone         = "${var.region}-b" # Different zone for redundancy
  tags         = ["swarm-node", "swarm-worker"]

  depends_on = [google_compute_instance.swarm_manager]

  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = var.disk_size_gb
    }
  }

  network_interface {
    network    = google_compute_network.swarm_network.id
    subnetwork = google_compute_subnetwork.swarm_subnet.id
    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    startup-script = "${file("${path.module}/scripts/startup_with_nginx.sh")}"
    ssh-keys       = "${var.ssh_user}:${file("${path.module}/keys/id_rsa.pub")} ${var.ssh_user}:${file("/home/piush/.ssh/id_rsa.pub")}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}
