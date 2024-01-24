locals {
  ansible_vars = <<-EOT
    %{for key, value in var.values~}${key}: ${value}
    %{endfor~}
  EOT
}

resource "local_file" "ansible_vars" {
  content  = local.ansible_vars
  filename = format("%s/terraform-generated.yml", var.config_relative_path)
}
