variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "project_prefix" {
  description = "Prefix to use for resource names"
  type        = string
  default     = "redis-swarm"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "machine_type" {
  description = "Machine type for the compute instances"
  type        = string
  default     = "e2-medium"
}

variable "vm_image" {
  description = "VM image to use for instances"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "disk_size_gb" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 50
}

variable "ssh_user" {
  description = "SSH username for the instances"
  type        = string
  default     = "ubuntu"
}

variable "ssh_pub_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "redis_password" {
  description = "Password for Redis"
  type        = string
  sensitive   = true
}

variable "credentials_file" {
  description = "Path to the GCP credentials file"
  type        = string
  default     = "~/.config/gcloud/application_default_credentials.json"
}
