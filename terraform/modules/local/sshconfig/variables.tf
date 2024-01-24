variable "instances_data" {
  description = "map of complex outputs of YC instances created with instance module"
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

variable "ssh_cluster_name" {
  description = "basically synonym of project to structure ssh configs"
}

variable "config_relative_path" {
  description = "where to store new generated file"
  type        = string
  default     = "./terraform-generated"
}
