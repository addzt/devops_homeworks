variable "cloud_id" {
  description  = "Default cloud_id"
  type         = string
  default      = "*************"
}

variable "folder_id" {
  description  = "Default folder_id"
  type         = string
  default      = "*************"
}

variable "cidr_blocks" {
  description  = "Default cidr blocks"
  type         = list(string)
  default      = ["192.168.15.0/24", "192.168.16.0/24"]
}

variable "nat_ip_address" {
  description = "Default nat ip address"
  type        = string
  default     = "84.201.164.144"
}

variable "ip_address" {
  description = "Default ip address"
  type        = string
  default     = "192.168.16.10"
}

variable "dest_prefix" {
  description = "Default destination prefix"
  type        = string
  default     = "0.0.0.0/0"
}

variable "zone" {
  description  = "Default zone"
  type         = list(string)
  default      = ["ru-central1-a", "ru-central1-b"]
}

variable "vm-1" {
  description = "Domain name"
  type        = string
  default     = "proxy-addzt"
}

variable "vm-2" {
  description = "List of server names"
  type        = list(string)
  default     = ["db01-addzt","db02-addzt","app-addzt","gitlab-addzt","runner-addzt","monitoring-addzt"]
}

variable "domain_name" {
  description = "My domain"
  type        =  string
  default     = "addzt.ru"
}

variable "default_email" {
  description = "My email"
  type        =  string
  default     = "addzt@yandex.ru"
}


variable "db_name" {
  description = "Name for wordpress"
  type = string
  default = "wordpress"
}

variable "db_user" {
  description = "User for wordpress"
  type = string
  default = "wordpress"
}

variable "db_password" {
  description = "Password for wordpress"
  type = string
  default = "wordpress"
}

variable "db_host" {
  description = "Host for wordpress"
  type = string
  default = "db01.addzt.ru"
}

