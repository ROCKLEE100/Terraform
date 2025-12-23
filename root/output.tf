# root/outputs.tf
# Root module outputs (aggregates outputs from all child modules)

# ============================================
# NETWORKING OUTPUTS
# ============================================

output "vpc_name" {
  description = "Name of the VPC network"
  value       = module.networking.vpc_name
}

output "vpc_id" {
  description = "ID of the VPC network"
  value       = module.networking.vpc_id
}

output "public_subnet_name" {
  description = "Name of the public subnet"
  value       = module.networking.public_subnet_name
}

output "public_subnet_cidr" {
  description = "CIDR range of the public subnet"
  value       = module.networking.public_subnet_cidr
}

output "private_subnet_name" {
  description = "Name of the private subnet"
  value       = module.networking.private_subnet_name
}

output "private_subnet_cidr" {
  description = "CIDR range of the private subnet"
  value       = module.networking.private_subnet_cidr
}

# ============================================
# SSH KEY OUTPUTS
# ============================================

output "ssh_private_key_secret_path" {
  description = "Path to SSH private key in Secret Manager"
  value       = module.ssh_key.private_key_secret_name
}

output "ssh_public_key_secret_path" {
  description = "Path to SSH public key in Secret Manager"
  value       = module.ssh_key.public_key_secret_name
}

# ============================================
# PUBLIC VM OUTPUTS
# ============================================

output "public_vm_name" {
  description = "Name of the public VM"
  value       = module.compute.public_vm_name
}

output "public_vm_external_ip" {
  description = "External IP of the public VM (access NGINX here)"
  value       = module.compute.public_vm_external_ip
}

output "public_vm_internal_ip" {
  description = "Internal IP of the public VM"
  value       = module.compute.public_vm_internal_ip
}

output "public_vm_zone" {
  description = "Zone where public VM is deployed"
  value       = module.compute.public_vm_zone
}

# ============================================
# PRIVATE VM OUTPUTS
# ============================================

output "private_vm_name" {
  description = "Name of the private VM"
  value       = module.compute.private_vm_name
}

output "private_vm_internal_ip" {
  description = "Internal IP of the private VM (no external IP)"
  value       = module.compute.private_vm_internal_ip
}

output "private_vm_zone" {
  description = "Zone where private VM is deployed"
  value       = module.compute.private_vm_zone
}

# ============================================
# APPLICATION ACCESS
# ============================================

output "nginx_url" {
  description = "URL to access NGINX on public VM"
  value       = module.compute.nginx_url
}

# ============================================
# SSH COMMANDS
# ============================================

output "ssh_to_public_vm_command" {
  description = "Command to SSH into public VM"
  value       = "gcloud compute ssh ${module.compute.public_vm_name} --zone=${module.compute.public_vm_zone} --project=${var.project_id}"
}

output "ssh_to_private_vm_command" {
  description = "Command to SSH into private VM (via IAP tunnel)"
  value       = "gcloud compute ssh ${module.compute.private_vm_name} --zone=${module.compute.private_vm_zone} --project=${var.project_id} --tunnel-through-iap"
}

# ============================================
# SERVICE ACCOUNT
# ============================================

output "vm_service_account_email" {
  description = "Service account email used by VMs"
  value       = module.compute.vm_service_account_email
}

# ============================================
# COMPLETE DEPLOYMENT SUMMARY
# ============================================

output "deployment_summary" {
  description = "Complete deployment summary"
  value = {
    project_id = var.project_id
    region     = var.region
    zone       = var.zone
    
    networking = {
      vpc_name        = module.networking.vpc_name
      public_subnet   = module.networking.public_subnet_cidr
      private_subnet  = module.networking.private_subnet_cidr
      nat_gateway     = module.networking.nat_gateway_name
    }
    
    public_vm = {
      name         = module.compute.public_vm_name
      external_ip  = module.compute.public_vm_external_ip
      internal_ip  = module.compute.public_vm_internal_ip
      zone         = module.compute.public_vm_zone
      nginx_url    = module.compute.nginx_url
    }
    
    private_vm = {
      name        = module.compute.private_vm_name
      internal_ip = module.compute.private_vm_internal_ip
      zone        = module.compute.private_vm_zone
    }
    
    access = {
      nginx_url           = module.compute.nginx_url
      ssh_public_vm       = "gcloud compute ssh ${module.compute.public_vm_name} --zone=${module.compute.public_vm_zone}"
      ssh_private_vm_iap  = "gcloud compute ssh ${module.compute.private_vm_name} --zone=${module.compute.private_vm_zone} --tunnel-through-iap"
    }
  }
}