
resource "yandex_iam_service_account" "service" {
  folder_id = var.yandex_folder_id
  name      = "bucket-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
  folder_id = var.yandex_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.service.id}"
  depends_on = [yandex_iam_service_account.service]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.service.id
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor-encrypter-decrypter" {
  folder_id = var.yandex_folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.service.id}"
}

resource "yandex_kms_symmetric_key" "secret-key" {
  name              = "encryption-key"
  default_algorithm = "AES_256"
  rotation_period   = "24h"
}

resource "yandex_storage_bucket" "ivanov-hw" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "ivanov-hw"
  acl    = "public-read"


  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.secret-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }  
}