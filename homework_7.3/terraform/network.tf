resource "yandex_vpc_network" "network_terraform" {
  name = "network-${terraform.workspace}"
}

resource "yandex_vpc_subnet" "subnet_terraform" {
  name           = "subnetwork-${terraform.workspace}"
  zone           = var.zone
  network_id     = yandex_vpc_network.network_terraform.id
  v4_cidr_blocks = ["192.168.15.0/24"]
}