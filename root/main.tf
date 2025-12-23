# root/main.tf
# Root module that orchestrates all child modules

# ============================================
# NETWORKING MODULE
# ============================================

module "networking" {
  source = "../modules/networking"
  
  project_prefix       = var.project_prefix
  region               = var.region
  environment          = var.environment
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
}

# ============================================
# SSH KEY MODULE
# ============================================

module "ssh_key" {
  source = "../modules/ssh-key"
  
  project_prefix = var.project_prefix
  
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# ============================================
# COMPUTE MODULE
# ============================================

module "compute" {
  source = "../modules/compute"
  
  # Basic configuration
  project_prefix = var.project_prefix
  zone           = var.zone
  
  # VM specifications
  machine_type    = var.machine_type
  vm_image        = var.vm_image
  boot_disk_size  = var.boot_disk_size
  boot_disk_type  = var.boot_disk_type
  
  # SSH configuration
  ssh_username   = var.ssh_username
  ssh_public_key = module.ssh_key.public_key_openssh
  
  # Network configuration from networking module
  public_subnet_self_link  = module.networking.public_subnet_self_link
  private_subnet_self_link = module.networking.private_subnet_self_link
  
  # Labels
  labels = {
    environment = var.environment
    managed_by  = "terraform"
    project     = var.project_prefix
  }
  
  # Ensure networking is created first
  depends_on = [
    module.networking
  ]
}