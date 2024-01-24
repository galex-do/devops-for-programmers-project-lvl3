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

variable "db_user" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "db"
}
