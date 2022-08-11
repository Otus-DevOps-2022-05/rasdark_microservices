output "external_ip_address_app" {
  value = yandex_compute_instance.app[*].network_interface.0.nat_ip_address
}
output "name" {
  value = yandex_compute_instance.app[*].name
}
