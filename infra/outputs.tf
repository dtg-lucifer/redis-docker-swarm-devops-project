output "manager_public_ip" {
  value       = google_compute_instance.swarm_manager.network_interface[0].access_config[0].nat_ip
  description = "The public IP address of the swarm manager node"
}

output "worker_public_ip" {
  value       = google_compute_instance.swarm_worker.network_interface[0].access_config[0].nat_ip
  description = "The public IP address of the swarm worker node"
}

output "manager_internal_ip" {
  value       = google_compute_instance.swarm_manager.network_interface[0].network_ip
  description = "The internal IP address of the swarm manager node"
}

output "worker_internal_ip" {
  value       = google_compute_instance.swarm_worker.network_interface[0].network_ip
  description = "The internal IP address of the swarm worker node"
}

output "app_url" {
  value       = "http://${google_compute_instance.swarm_manager.network_interface[0].access_config[0].nat_ip}:5001"
  description = "The URL to access the application"
}

# output "deployment_script" {
#   value = local_file.deployment_script.filename
#   description = "Path to the deployment script"
# }
