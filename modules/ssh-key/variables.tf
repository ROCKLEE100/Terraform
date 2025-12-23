

variable "project_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}