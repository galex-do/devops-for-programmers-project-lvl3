output "output_network_id" {
  description = "network ID"
  value       = yandex_vpc_network.net.id
}

output "output_subnet_id" {
  description = "Subnet ID"
  value       = yandex_vpc_subnet.subnet.id
}
