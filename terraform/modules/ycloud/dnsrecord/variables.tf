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

variable "zone_id" {
  description = "ID of used cloud DNS zone"
  type        = string
}

variable "external_ip" {
  description = "White IP of ALB, NLB or istance used to map records from dns"
  type        = list(string)
}
