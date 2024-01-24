variable "name" {
  description = "Instance name"
  type        = string
}

variable "project" {
  description = "Commonized project name"
  type        = string
  default     = "project"
}

variable "settings" {}

variable "zone" {
  description = "Zone where instance belongs"
  type        = string
  default     = "ru-central1-d"
}

variable "subnet_id" {
  description = "subnet ID to which instance will be binded. Can acquire network module output"
  type        = string
}

variable "entry_user" {
  description = "default linux user on new instances"
  type        = string
  default     = "ubuntu"
}

variable "entry_key" {
  description = "local filepath to public part of rsa key, which would be added to authorized keys on new instances"
  type        = string
}
