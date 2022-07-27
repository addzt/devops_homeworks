output "instance_external_ip" {
  value = yandex_compute_instance.vm-test1.network_interface.0.nat_ip_address
}

output "instance_internal_ip" {
  value = yandex_compute_instance.vm-test1.network_interface.0.ip_address
}

output "ipv4_address" {
  value = yandex_vpc_subnet.subnet_terraform.id
}

