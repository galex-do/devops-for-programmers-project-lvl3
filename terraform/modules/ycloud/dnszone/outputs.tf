output "output_zone_id" {
  description = "zone ID"
  value       = yandex_dns_zone.zone.id
}

output "output_certificate_id" {
  description = "SSL certificate ID"
  value       = yandex_cm_certificate.certificate.id
}
