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

variable "project" {
  description = "Commonized project name"
  type        = string
  default     = "project"
}
