variable "project" {
  description = "Commonized project name"
  type        = string
}

variable "net_name" {
  description = "Name of YCloud network"
  type        = string
  default     = "net"
}

variable "subnet_name" {
  description = "Name of YCloud subnet"
  type        = string
  default     = "subnet"
}

variable "subnet_zone" {
  description = "Zone where subnet belongs"
  type        = string
  default     = "ru-central1-d"
}

variable "private_net_cidr" {
  description = "YCloud subnet addresses grid"
  type        = list(string)
  default     = ["192.168.192.0/24"]
}

variable "instances" {
  description = "Map of virtual machines. Name of element = name of instance, values = settings of instance"
}

variable "dns-public" {
  description = "Map to configure behaviour of dns public module"
  type = object({
    description = string
    zone        = string
    records     = list(string)
  })
}

variable "app" {
  description = "structured data about app functionality"
}

variable "db" {
  description = "Map describing configuration of postgresql cluster"
  type = object({
    type          = string
    version       = number
    cluster_scale = string
    disk_size     = number
  })
  default = {
    type          = "postgres"
    version       = 15
    cluster_scale = "s2.micro"
    disk_size     = 15
  }
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "db"
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "user"
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "password"
  sensitive   = true
}
