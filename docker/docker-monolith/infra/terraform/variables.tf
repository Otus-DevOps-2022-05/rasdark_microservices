variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}
variable "region_id" {
  # Значение региона по умолчанию
  description = "region"
  default     = "ru-central1"
}
variable "zone" {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable "public_key_path" {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable "image_family" {
  description = "Family of disk image for reddit app"
  default     = "docker"
}
variable "ip_range" {
  description = "IP Range for Network"
  default     = "192.168.161.0/24"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "service_account_key_file" {
  description = "key .json"
}
variable "instance_count" {
  description = "count of instance"
  default     = 1
}
