variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable subnet_id {
  description = "Subnet"
}
variable node_count {
  description = "count node"
  default     = 2
}
variable cores {
  description = "VM cores"
  default     = 4
}
variable memory {
  description = "VM memory"
  default     = 16
}
variable disk {
  description = "Disk size"
  default     = 64
}
variable network_id {
  description = "Network id"
}
variable service_account_id {
  description = "Service account ID"
}
