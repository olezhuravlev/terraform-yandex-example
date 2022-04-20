# Config to test 'count' operator.
module "yc-instance" {
  source             = "./modules/terraform-yandex-compute-instance"
  yandex_cloud_id    = "b1g8mq58h421raomnd64"
  folder_id          = "b1g4ebtqkeg1iur72o8c"
  path_to_public_key = "~/.ssh/id_rsa.pub"
}
