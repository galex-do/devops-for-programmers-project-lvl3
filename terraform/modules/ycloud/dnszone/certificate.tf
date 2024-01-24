resource "yandex_cm_certificate" "certificate" {
  name    = format("%s-certificate", var.project)
  domains = [format("*.%s", trimsuffix(var.dns.zone, "."))]

  managed {
    challenge_type  = "DNS_CNAME"
    challenge_count = 1 # "example.com" and "*.example.com" has the same DNS_CNAME challenge
  }
}

resource "yandex_dns_recordset" "cm_record" {
  count   = yandex_cm_certificate.certificate.managed[0].challenge_count
  zone_id = yandex_dns_zone.zone.id
  name    = yandex_cm_certificate.certificate.challenges[count.index].dns_name
  type    = yandex_cm_certificate.certificate.challenges[count.index].dns_type
  data    = [yandex_cm_certificate.certificate.challenges[count.index].dns_value]
  ttl     = 60
}
