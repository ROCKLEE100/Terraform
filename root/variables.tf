# root/variables.tf
# Root module variables

# ============================================
# PROJECT CONFIGURATION
# ============================================

variable "project_id" {
  description = "GCP Project ID"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty."
  }
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for compute instances"
  type        = string
  default     = "us-central1-a"
}

variable "project_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "assignment"
  validation {
    condition     = can(regex("^[a-z][-a-z0-9]*$", var.project_prefix))
    error_message = "Prefix must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "assignment"
}

# ============================================
# NETWORKING CONFIGURATION
# ============================================

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
  validation {
    condition     = can(cidrhost(var.public_subnet_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
  validation {
    condition     = can(cidrhost(var.private_subnet_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

# ============================================
# COMPUTE CONFIGURATION
# ============================================

variable "machine_type" {
  description = "Machine type for compute instances"
  type        = string
  default     = "e2-micro"
}

variable "vm_image" {
  description = "OS image for compute instances"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
  validation {
    condition     = var.boot_disk_size >= 10 && var.boot_disk_size <= 1000
    error_message = "Boot disk size must be between 10 and 1000 GB."
  }
}

variable "boot_disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-standard"
  validation {
    condition     = contains(["pd-standard", "pd-ssd", "pd-balanced"], var.boot_disk_type)
    error_message = "Boot disk type must be pd-standard, pd-ssd, or pd-balanced."
  }
}

# ============================================
# SSH CONFIGURATION
# ============================================

variable "ssh_username" {
  description = "SSH username for VM access"
  type        = string
  default     = "gcpuser"
  validation {
    condition     = can(regex("^[a-z][-a-z0-9]*$", var.ssh_username))
    error_message = "SSH username must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}