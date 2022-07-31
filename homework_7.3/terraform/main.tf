terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "addzt-bucket"
    region     = "ru-central1"
    key        = "./terraform/terraform.tfstate"
    access_key = "access_key"
    secret_key = "secret_key"

    skip_region_validation = true
    skip_credentials_validation = true
  }
}

data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-test1" {
  name          = "vm-test1-${count.index+1}-${terraform.workspace}"
  platform_id   = local.instance_type[terraform.workspace]
  count         = local.vm_count[terraform.workspace]
  zone          = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu_image.id
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_terraform.id
    nat       = true
  }
}

resource "yandex_compute_instance" "vm-test2" {
  name                  = "vm-test2-${each.key+1}-${terraform.workspace}"
  platform_id           = local.instance_type[terraform.workspace]
  for_each              = {for type, vm in local.vm_count2: type => vm
                          if vm.workspace == terraform.workspace}
  zone                  = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu_image.id
      type        = "network-nvme"
      size        = "15"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_terraform.id
    nat       = true
  }
}
