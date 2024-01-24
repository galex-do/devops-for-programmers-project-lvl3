#-----------
#- Network -
#-----------

resource "yandex_vpc_network" "net" {
  name = var.net_name
}

#----------
#- Subnet -
#----------

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet_name
  zone           = var.subnet_zone
  route_table_id = var.route_table_id
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = var.private_net_cidr
}
