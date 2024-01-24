variable "values" {
  description = "map of key-value variables for ansible"
}

variable "config_relative_path" {
  description = "where to store new generated file"
  type        = string
  default     = "./terraform-generated"
}
