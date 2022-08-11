variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable subnet_id {
  description = "Subnet ID"
}
variable image_family {
  description = "Family of disk image for reddit app"
  default     = "reddit-app"
}
variable instance_count {
  description = "count of instance"
  default     = 1
}
