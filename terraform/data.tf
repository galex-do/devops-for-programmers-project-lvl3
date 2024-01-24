data "sops_file" "secrets" {
  source_file = "secrets/secret.enc.json"
}

data "sops_file" "sa-key" {
  source_file = "secrets/key.enc.json"
}

output "out-ycloud-id" {
  value     = data.sops_file.secrets.data["cloud_id"]
  sensitive = true
}

output "out-ycloud-folder" {
  value     = data.sops_file.secrets.data["folder_id"]
  sensitive = true
}
