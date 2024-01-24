resource "yandex_alb_load_balancer" "alb" {
  name       = format("%s-alb", var.project)
  network_id = var.network_id

  allocation_policy {
    location {
      zone_id   = var.zone
      subnet_id = var.subnet_id
    }
  }

  listener {
    name = format("%s-alb-http-lsnr", var.project)
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      redirects {
        http_to_https = true
      }
    }
  }

  listener {
    name = format("%s-alb-https-lsnr", var.project)
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [443]
    }
    tls {
      default_handler {
        http_handler {
          http_router_id = yandex_alb_http_router.router.id
        }
        certificate_ids = ["${var.ssl_cert_id}"]
      }
    }
  }
}

resource "yandex_alb_target_group" "target-group" {
  name = format("%s-alb-tg", var.project)
  dynamic "target" {
    for_each = var.targets
    content {
      subnet_id  = target.value["network_interface"][0]["subnet_id"]
      ip_address = target.value["network_interface"][0]["ip_address"]
    }
  }
}

resource "yandex_alb_backend_group" "backend-group" {
  name = format("%s-alb-backend", var.project)

  http_backend {
    name             = "http-backend"
    weight           = 1
    port             = var.backend_port
    target_group_ids = ["${yandex_alb_target_group.target-group.id}"]

    healthcheck {
      timeout  = var.healthcheck.timeout
      interval = var.healthcheck.interval
      http_healthcheck {
        path = var.healthcheck.path
      }
    }
  }
}

resource "yandex_alb_http_router" "router" {
  name   = format("%s-alb-router", var.project)
  labels = {}
}

resource "yandex_alb_virtual_host" "host" {
  name           = format("%s-alb-vh", var.project)
  authority      = [trimsuffix(var.dns.records[0], ".")]
  http_router_id = yandex_alb_http_router.router.id
  route {
    name = "my-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
      }
    }
  }
}
