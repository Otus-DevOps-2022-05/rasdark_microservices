terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

data "external" "env" {
  program = ["${path.root}/files/env.sh"]
}

data "yandex_compute_image" "app-image" {
  family    = var.image_family
  folder_id = data.external.env.result["folder_id"]
}

resource "yandex_compute_instance" "app" {
  name  = "docker-node-${count.index}"
  count = var.instance_count

  labels = {
    tags = "reddit-app"
  }
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.app-image.id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

resource "local_file" "inventory" {
  content = templatefile("inventory.tpl",
    {
      docker_hosts = yandex_compute_instance.app.*.network_interface.0.nat_ip_address
    }
  )
  filename = "../ansible/inventory.ini"
}
