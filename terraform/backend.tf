terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    region                      = "ru-central1"
    key                         = "hexlet-tf3"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
