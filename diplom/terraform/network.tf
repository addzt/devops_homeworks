# NETWORK

resource "yandex_vpc_network" "network_terraform" {
  name           = "network"
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public-subnet"
  v4_cidr_blocks = [var.cidr_blocks[1]]
  zone           = var.zone[1]
  network_id     = yandex_vpc_network.network_terraform.id
}

resource "yandex_vpc_route_table" "nat-instance-route" {
  network_id = yandex_vpc_network.network_terraform.id

  static_route {
    destination_prefix = var.dest_prefix
    next_hop_address   = yandex_compute_instance.virtual_machine-1.network_interface.0.ip_address
    }
}

resource "yandex_vpc_subnet" "private-subnet" {
  name           = "private-subnet"
  v4_cidr_blocks = [var.cidr_blocks[0]]
  zone           = var.zone[0]
  network_id     = yandex_vpc_network.network_terraform.id
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

# DNS-ZONE

resource "yandex_dns_zone" "main" {
  zone             = "addzt.ru."
  public           = true
}

resource "yandex_dns_recordset" "main-recordset" {
  zone_id = yandex_dns_zone.main.id
  name    = "addzt.ru."
  type    = "A"
  ttl     = 200
  data    = ["${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "wordpress" {
  zone_id = yandex_dns_zone.main.id
  name = "www"
  type = "A"
  ttl = 200
  data = ["${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "gitlab" {
  zone_id = yandex_dns_zone.main.id
  name    = "gitlab"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "grafana" {
  zone_id = yandex_dns_zone.main.id
  name    = "grafana"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "prometheus" {
  zone_id = yandex_dns_zone.main.id
  name    = "prometheus"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "alertmanager" {
  zone_id = yandex_dns_zone.main.id
  name    = "alertmanager"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"]
}