# modules/networking/outputs.tf
# Outputs from networking module

output "vpc_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.custom_vpc.id
}

output "vpc_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.custom_vpc.name
}

output "vpc_self_link" {
  description = "Self link of the VPC network"
  value       = google_compute_network.custom_vpc.self_link
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = google_compute_subnetwork.public_subnet.id
}

output "public_subnet_name" {
  description = "Name of the public subnet"
  value       = google_compute_subnetwork.public_subnet.name
}

output "public_subnet_cidr" {
  description = "CIDR range of the public subnet"
  value       = google_compute_subnetwork.public_subnet.ip_cidr_range
}

output "public_subnet_self_link" {
  description = "Self link of the public subnet"
  value       = google_compute_subnetwork.public_subnet.self_link
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = google_compute_subnetwork.private_subnet.id
}

output "private_subnet_name" {
  description = "Name of the private subnet"
  value       = google_compute_subnetwork.private_subnet.name
}

output "private_subnet_cidr" {
  description = "CIDR range of the private subnet"
  value       = google_compute_subnetwork.private_subnet.ip_cidr_range
}

output "private_subnet_self_link" {
  description = "Self link of the private subnet"
  value       = google_compute_subnetwork.private_subnet.self_link
}

output "nat_gateway_name" {
  description = "Name of the Cloud NAT gateway"
  value       = google_compute_router_nat.nat_gateway.name
}

output "router_name" {
  description = "Name of the Cloud Router"
  value       = google_compute_router.nat_router.name
}