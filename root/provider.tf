

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
  
  # Backend configuration for storing state in GCS
  backend "gcs" {
    bucket = "YOUR_BUCKET_NAME"  # Will be replaced by GitHub Actions
    prefix = "terraform/state"
  }
}

# Google Cloud Provider
provider "google" {
  project = var.project_id
  region  = var.region
}