# modules/ssh-key/outputs.tf
# Outputs from SSH key module

output "public_key_openssh" {
  description = "SSH public key in OpenSSH format"
  value       = tls_private_key.vm_ssh_key.public_key_openssh
  sensitive   = true
}

output "private_key_pem" {
  description = "SSH private key in PEM format"
  value       = tls_private_key.vm_ssh_key.private_key_pem
  sensitive   = true
}

output "private_key_secret_id" {
  description = "Secret Manager secret ID for private key"
  value       = google_secret_manager_secret.ssh_private_key.secret_id
}

output "private_key_secret_name" {
  description = "Secret Manager secret name for private key"
  value       = google_secret_manager_secret.ssh_private_key.name
}

output "public_key_secret_id" {
  description = "Secret Manager secret ID for public key"
  value       = google_secret_manager_secret.ssh_public_key.secret_id
}

output "public_key_secret_name" {
  description = "Secret Manager secret name for public key"
  value       = google_secret_manager_secret.ssh_public_key.name
}

output "key_algorithm" {
  description = "Algorithm used for SSH key"
  value       = tls_private_key.vm_ssh_key.algorithm
}

output "key_size" {
  description = "Size of RSA key in bits"
  value       = tls_private_key.vm_ssh_key.rsa_bits
}