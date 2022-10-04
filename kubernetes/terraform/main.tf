terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_vpc_network" "k8s-net" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s-subnet" {
  name           = "k8s-subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s-net.id
  v4_cidr_blocks = [var.ip_range]

}

data "yandex_compute_image" "ubuntu-image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "k8s" {
  name  = "k8s-${count.index}"
  count = var.instance_count

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-image.image_id
      size     = 40
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

locals {
  names = yandex_compute_instance.k8s.*.name
  ips   = yandex_compute_instance.k8s.*.network_interface.0.nat_ip_address
}

resource "local_file" "inventory" {
  content = templatefile("inventory.tpl",
    {
      names = local.names,
      addrs = local.ips,
    }
  )
  filename = "../ansible/inventory.ini"

  provisioner "local-exec" {
    command     = "ansible-playbook cluster_deploy.yml"
    working_dir = "../ansible"
  }
}
