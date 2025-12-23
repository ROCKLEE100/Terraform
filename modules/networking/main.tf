

resource "google_compute_network" "custom_vpc" {
  name                    = "${var.project_prefix}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  description             = "Custom VPC for ${var.environment} environment"
}


resource "google_compute_subnetwork" "public_subnet" {
  name          = "${var.project_prefix}-public-subnet"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.custom_vpc.id
  description   = "Public subnet for internet-facing resources"
  
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}


resource "google_compute_subnetwork" "private_subnet" {
  name          = "${var.project_prefix}-private-subnet"
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.custom_vpc.id
  description   = "Private subnet for internal resources"
  
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}


resource "google_compute_router" "nat_router" {
  name    = "${var.project_prefix}-nat-router"
  region  = var.region
  network = google_compute_network.custom_vpc.id
  
  bgp {
    asn = 64514
  }
}


resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${var.project_prefix}-nat-gateway"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  
  subnetwork {
    name                    = google_compute_subnetwork.private_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}


resource "google_compute_firewall" "allow_http_https" {
  name    = "${var.project_prefix}-allow-http-https"
  network = google_compute_network.custom_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public-vm", "web-server"]
  
  description = "Allow HTTP and HTTPS traffic from internet to public VMs"
}

resource "google_compute_firewall" "allow_ssh_iap" {
  name    = "${var.project_prefix}-allow-ssh-iap"
  network = google_compute_network.custom_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["public-vm", "private-vm", "ssh-enabled"]
  
  description = "Allow SSH from Identity-Aware Proxy"
}


resource "google_compute_firewall" "allow_internal" {
  name    = "${var.project_prefix}-allow-internal"
  network = google_compute_network.custom_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  
  allow {
    protocol = "icmp"
  }
  
  source_ranges = [
    var.public_subnet_cidr,
    var.private_subnet_cidr
  ]
  
  description = "Allow all internal traffic within VPC"
}


resource "google_compute_firewall" "allow_health_checks" {
  name    = "${var.project_prefix}-allow-health-checks"
  network = google_compute_network.custom_vpc.name
  
  allow {
    protocol = "tcp"
  }
  
  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]
  
  target_tags = ["public-vm", "private-vm"]
  
  description = "Allow health checks from Google Cloud load balancers"
}