
module "networking" {
  source = "../modules/networking"
  
  project_prefix       = var.project_prefix
  region               = var.region
  environment          = var.environment
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
}



module "ssh_key" {
  source = "../modules/ssh-key"
  
  project_prefix = var.project_prefix
  
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}



module "compute" {
  source = "../modules/compute"
  
  
  project_prefix = var.project_prefix
  zone           = var.zone
  
  
  machine_type    = var.machine_type
  vm_image        = var.vm_image
  boot_disk_size  = var.boot_disk_size
  boot_disk_type  = var.boot_disk_type
  
  
  ssh_username   = var.ssh_username
  ssh_public_key = module.ssh_key.public_key_openssh
  
  
  public_subnet_self_link  = module.networking.public_subnet_self_link
  private_subnet_self_link = module.networking.private_subnet_self_link
  
  #
  labels = {
    environment = var.environment
    managed_by  = "terraform"
    project     = var.project_prefix
  }
  
  
  depends_on = [
    module.networking
  ]
}