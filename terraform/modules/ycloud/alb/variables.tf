variable "project" {
  description = "Commonized project name"
  type        = string
  default     = "project"
}

variable "network_id" {
  description = "network ID to which alb will be binded. Can acquire network module output"
  type        = string
}

variable "zone" {
  description = "Zone where alb listener belongs"
  type        = string
  default     = "ru-central1-d"
}

variable "subnet_id" {
  description = "subnet ID to which alb listener will be binded. Can acquire network module output"
  type        = string
}

variable "dns" {
  description = "dns structure data including info about zone and host"
  type = object(
    {
      description = string
      zone        = string
      records     = list(string)
    }
  )
  default = {
    description = "Public DNS"
    zone        = "my.site."
    records = [
      "app.my.site.ru."
    ]
  }
}

variable "backend_port" {
  description = "port served by backend application"
  type        = number
  default     = 80
}

variable "targets" {
  description = "instances data to complect target group"
}

variable "healthcheck" {
  description = "configuration of backend healtcheck of application"
  type = object(
    {
      timeout  = string
      interval = string
      path     = string
    }
  )
  default = {
    timeout  = "1s"
    interval = "1s"
    path     = "/"
  }
}

variable "ssl_cert_id" {
  description = "ID of cloud CM generated domain level certificate"
  type        = string
}
