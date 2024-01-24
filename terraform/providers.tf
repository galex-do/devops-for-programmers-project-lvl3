terraform {
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.7.2"
    }
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84.0"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "yandex" {
  service_account_key_file = data.sops_file.sa-key.raw
  cloud_id                 = data.sops_file.secrets.data["cloud_id"]
  folder_id                = data.sops_file.secrets.data["folder_id"]
  zone                     = "ru-central1-a"
}

provider "datadog" {
  api_key = data.sops_file.secrets.data["datadog_api_key"]
  app_key = data.sops_file.secrets.data["datadog_app_key"]
  api_url = data.sops_file.secrets.data["datadog_api_url"]
}
