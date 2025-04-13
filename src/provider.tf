terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "yandex" {
  service_account_key_file = "/home/ivanov/key.json"
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = var.default_zone
}