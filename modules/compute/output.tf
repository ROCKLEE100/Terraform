# modules/compute/outputs.tf
# Outputs from compute module

# ============================================
# PUBLIC VM OUTPUTS
# ============================================

output "public_vm_id" {
  description = "ID of the public VM"
  value       = google_compute_instance.public_vm.id
}

output "public_vm_name" {
  description = "Name of the public VM"
  value       = google_compute_instance.public_vm.name
}

output "public_vm_external_ip" {
  description = "External IP address of the public VM"
  value       = google_compute_instance.public_vm.network_interface[0].access_config[0].nat_ip
}

output "public_vm_internal_ip" {
  description = "Internal IP address of the public VM"
  value       = google_compute_instance.public_vm.network_interface[0].network_ip
}

output "public_vm_zone" {
  description = "Zone where public VM is deployed"
  value       = google_compute_instance.public_vm.zone
}

output "public_vm_self_link" {
  description = "Self link of the public VM"
  value       = google_compute_instance.public_vm.self_link
}

# ============================================
# PRIVATE VM OUTPUTS
# ============================================

output "private_vm_id" {
  description = "ID of the private VM"
  value       = google_compute_instance.private_vm.id
}

output "private_vm_name" {
  description = "Name of the private VM"
  value       = google_compute_instance.private_vm.name
}

output "private_vm_internal_ip" {
  description = "Internal IP address of the private VM (no external IP)"
  value       = google_compute_instance.private_vm.network_interface[0].network_ip
}

output "private_vm_zone" {
  description = "Zone where private VM is deployed"
  value       = google_compute_instance.private_vm.zone
}

output "private_vm_self_link" {
  description = "Self link of the private VM"
  value       = google_compute_instance.private_vm.self_link
}

# ============================================
# SERVICE ACCOUNT OUTPUT
# ============================================

output "vm_service_account_email" {
  description = "Email of the service account used by VMs"
  value       = google_service_account.vm_service_account.email
}

output "vm_service_account_id" {
  description = "ID of the service account used by VMs"
  value       = google_service_account.vm_service_account.id
}

# ============================================
# NGINX ACCESS OUTPUT
# ============================================

output "nginx_url" {
  description = "URL to access NGINX on public VM"
  value       = "http://${google_compute_instance.public_vm.network_interface[0].access_config[0].nat_ip}"
}