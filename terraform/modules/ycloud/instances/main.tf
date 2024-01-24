resource "yandex_compute_disk" "binded_disk" {
  count = length(var.settings.secondary_disks)
  name  = format("%s-%s-sd%s", var.project, var.name, count.index)
  type  = element(var.settings.secondary_disks, count.index).type
  size  = element(var.settings.secondary_disks, count.index).size
  zone  = var.zone
}

resource "yandex_compute_instance" "instance" {
  name                      = format("%s-%s", var.project, var.name)
  hostname                  = format("%s-%s", var.project, var.name)
  zone                      = var.zone
  platform_id               = var.settings.platform
  allow_stopping_for_update = true
  resources {
    cores         = var.settings.cores
    memory        = var.settings.memory
    core_fraction = var.settings.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.settings.boot_image_id
      size     = var.settings.disk_size
      type     = var.settings.disk_type
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.binded_disk
    content {
      auto_delete = true
      disk_id     = secondary_disk.value["id"]
    }
  }

  network_interface {
    subnet_id          = var.subnet_id
    ip_address         = var.settings.ip_address
    nat                = var.settings.provide_public_ip
    nat_ip_address     = var.settings.fixed_public_ip
    security_group_ids = var.settings.secgroup_ids
  }

  dynamic "network_interface" {
    for_each = var.settings.additional_networks
    content {
      subnet_id  = network_interface.value["subnet_id"]
      ip_address = network_interface.value["ip_address"]
      nat        = false
    }
  }

  metadata = {
    ssh-keys  = "${var.entry_user}:${file(var.entry_key)}"
    user-data = "#cloud-config\nusers:\n  - name: ${var.entry_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file(var.entry_key)}\n"
  }

  depends_on = [yandex_compute_disk.binded_disk]
}
