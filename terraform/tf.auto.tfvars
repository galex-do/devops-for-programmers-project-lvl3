# NETWORKS
# ========

project = "hexlet3"

dns-public = {
  description = "Public DNS"
  zone        = "oo-woo.ru."
  records = [
    "app.oo-woo.ru."
  ]
}

app = {
  service_port = 80
  healthcheck = {
    timeout  = "1s"
    interval = "1s"
    path     = "/"
  }
  database_name = "db"
}

db = {
  type          = "postgres"
  version       = 15
  cluster_scale = "s2.micro"
  disk_size     = 15
}

# INSTANCES
# =============================

instances = {
  node-1 = {
    cores               = 2
    memory              = 2
    core_fraction       = 20
    platform            = "standard-v3"
    boot_image_id       = "fd8vq2agp2bltpk94ule" # Container optimized image
    disk_size           = 30                     # container optimized minimal cap
    disk_type           = "network-hdd"
    ip_address          = "192.168.192.100"
    provide_public_ip   = true
    fixed_public_ip     = null
    secondary_disks     = []
    secgroup_ids        = []
    additional_networks = []
  }
  node-2 = {
    cores               = 2
    memory              = 2
    core_fraction       = 20
    platform            = "standard-v3"
    boot_image_id       = "fd8vq2agp2bltpk94ule" # Container optimized image
    disk_size           = 30                     # container optimized minimal cap
    disk_type           = "network-hdd"
    ip_address          = "192.168.192.101"
    provide_public_ip   = true
    fixed_public_ip     = null
    secondary_disks     = []
    secgroup_ids        = []
    additional_networks = []
  }
}
