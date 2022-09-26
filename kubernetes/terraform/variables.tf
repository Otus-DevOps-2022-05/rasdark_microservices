variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "path to private key"
}
variable ip_range {
  description = "IP Range for Network"
  default = "192.168.161.0/24"
  type = string
}
variable instance_count {
  description = "count instances"
  default     = 1
}
