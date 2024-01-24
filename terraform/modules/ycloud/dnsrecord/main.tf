resource "yandex_dns_recordset" "dns_record" {
  for_each = toset(var.dns.records)
  zone_id  = var.zone_id
  name     = each.value
  type     = "A"
  ttl      = 300
  data     = var.external_ip
}
