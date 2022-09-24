#OUTPUT LOCAL IP AND PUBLIC OUTPUTS

output "external_ip_address_virtual_machine-1_yandex_cloud" {
  value = "external ip ${yandex_compute_instance.virtual_machine-1.name}: ${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_virtual_machine-1_yandex_cloud" {
  value = "internal ip ${yandex_compute_instance.virtual_machine-1.name}: ${yandex_compute_instance.virtual_machine-1.network_interface.0.ip_address}"
}

output "internal_ip_address_virtual_machine-2_yandex_cloud" {
  value = [
   for virtual_machine in yandex_compute_instance.virtual_machine-2[*]:
   "internal ip ${virtual_machine.name}: ${virtual_machine.network_interface.0.ip_address}"
  ]
}
