
variable "project_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "assignment"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  validation {
    condition     = can(cidrhost(var.public_subnet_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  validation {
    condition     = can(cidrhost(var.private_subnet_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}