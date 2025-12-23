
variable "project_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "zone" {
  description = "GCP zone for compute instances"
  type        = string
}

variable "machine_type" {
  description = "Machine type for compute instances"
  type        = string
}

variable "vm_image" {
  description = "OS image for compute instances"
  type        = string
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
}

variable "boot_disk_type" {
  description = "Boot disk type"
  type        = string
}

variable "ssh_username" {
  description = "SSH username for VM access"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

variable "public_subnet_self_link" {
  description = "Self link of the public subnet"
  type        = string
}

variable "private_subnet_self_link" {
  description = "Self link of the private subnet"
  type        = string
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}