variable "net_name" {
  description = "cloud region network name"
  type        = string
  default     = "net"
}

variable "subnet_name" {
  description = "cloud zonal network name"
  type        = string
  default     = "subnet"
}

variable "subnet_zone" {
  description = "zone where subnet is binded"
  type        = string
  default     = "ru-central1-d"
}

variable "private_net_cidr" {
  description = "YCloud subnet addresses grid"
  type        = list(string)
  default     = ["192.168.192.0/24"]
}

variable "route_table_id" {}
