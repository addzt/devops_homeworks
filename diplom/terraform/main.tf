#CREATE BUCKET AND COMPUTE_INSTANCE

terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "bucket-diplom"
    region     = "ru-central1"
    key        = "./terraform/terraform.tfstate"
    access_key = "**********"
    secret_key = "*************"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

data "yandex_compute_image" "nat-instance_image" {
  family       = "nat-instance-ubuntu"
}

data "yandex_compute_image" "ubuntu_image" {
  family       = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "virtual_machine-1" {
  name         = "${var.vm-1}"
  zone         = var.zone[1]

  resources {
    cores      = 2
    memory     = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat-instance_image.id
      type     = "network-nvme"
      size     = "15"
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.public-subnet.id
    nat            = true
    nat_ip_address = var.nat_ip_address
    ip_address     = var.ip_address
  }

  metadata = {
    ssh-keys   = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "virtual_machine-2" {
  count        = length(var.vm-2)
  name         = "${var.vm-2[count.index]}"
  zone         = var.zone[0]

  resources {
    cores      = 4
    memory     = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
      type     = "network-nvme"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.private-subnet.id
    nat        = false
    ip_address = "192.168.15.1${count.index+1}"
  }

  metadata = {
    ssh-keys   = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

