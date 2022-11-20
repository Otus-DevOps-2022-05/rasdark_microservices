terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_kubernetes_cluster" "k8s-cluster" {
  name       = "k8s-dev"
  network_id = var.network_id

  master {
    version = "1.21"
    zonal {
      # zone      = var.zone
      subnet_id = var.subnet_id
    }
    public_ip = true
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  release_channel = "RAPID"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "k8s-node" {
  cluster_id = yandex_kubernetes_cluster.k8s-cluster.id
  version    = "1.21"
  name = "k8s-node"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = [var.subnet_id]
    }

    resources {
      cores  = var.cores
      memory = var.memory
    }

    boot_disk {
      type = "network-ssd"
      size = var.disk
    }

    metadata = {
      ssh-keys = "ubuntu:${file(var.public_key_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count
    }
  }
}
