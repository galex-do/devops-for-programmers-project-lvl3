resource "yandex_dns_zone" "zone" {
  name        = format("%s-dns-public", var.project)
  description = var.dns.description
  labels      = {}
  zone        = var.dns.zone
  public      = true
}
