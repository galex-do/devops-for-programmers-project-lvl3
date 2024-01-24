output "output_internal_ip" {
  description = "instance internal IP"
  value       = yandex_compute_instance.instance.network_interface.0.ip_address
}

output "output_external_ip" {
  description = "instance public IP"
  value       = yandex_compute_instance.instance.network_interface.0.nat_ip_address
}

output "all" {
  value = yandex_compute_instance.instance
}
