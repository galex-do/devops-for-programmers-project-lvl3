output "all" {
  value = yandex_alb_load_balancer.alb
}

output "output_external_ip" {
  value = yandex_alb_load_balancer.alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}
