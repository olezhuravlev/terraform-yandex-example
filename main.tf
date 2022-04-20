# Instance settings.

variable yandex-cloud-id { default = "" }
variable folder_id { default = "" }

variable yandex-cloud-zone { default = "ru-central1-a" }
variable image_family { default = "centos-8" }
variable users { default = "centos" }

variable instance_count { default = 1 }
variable instance_name { default = "instance" }
variable instance_description { default = "" }
variable instance_type { default = "standard-v1" }

# VM settings.
variable cores { default = "1" }
variable core_fraction { default = "20" }
variable memory { default = "2" }
variable boot_disk { default = "network-hdd" }
variable disk_size { default = "20" }
variable subnet_id { default = "" }
variable nat { default = "false" }

# Service variables.
#start numbering from X+1 (e.g. name-1 if '0', name-3 if '2', etc.)
variable count_offset { default = 0 }
#server number format (-1, -2, etc.)
variable count_format { default = "%01d" }

# Provider must be specified in every module.
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id = var.yandex-cloud-id
  zone     = var.yandex-cloud-zone
}

# Retrieves existing public image of a family.
data "yandex_compute_image" "image" {
  family = var.image_family
}

# Declare instance.
resource "yandex_compute_instance" "instance" {
  count       = var.instance_count
  folder_id   = var.folder_id
  name        = "${var.instance_name}-${format(var.count_format, var.count_offset+count.index+1)}"
  description = var.instance_description
  platform_id = var.instance_type
  hostname    = "${var.instance_name}-${format(var.count_format, var.count_offset+count.index+1)}"
  zone        = var.yandex-cloud-zone

  resources {
    cores         = var.cores
    core_fraction = var.core_fraction
    memory        = var.memory
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type     = var.boot_disk
      size     = var.disk_size
    }
  }
  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.users}:${file("~/.ssh/id_rsa.pub")}"
  }

  allow_stopping_for_update = true
}