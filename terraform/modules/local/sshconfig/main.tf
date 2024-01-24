locals {
  ssh_config = <<-EOT
    %{for name, settings in var.instances_data~}Host ${var.ssh_cluster_name}_${name}
      User ${var.entry_user}
      HostName ${settings.network_interface[0].nat_ip_address}
      IdentityFile ${var.entry_key}
      StrictHostKeyChecking no

    %{endfor~}
  EOT
}

resource "local_file" "SSHConfig" {
  content  = local.ssh_config
  filename = format("%s/ssh-config-%s", var.config_relative_path, var.ssh_cluster_name)
}
