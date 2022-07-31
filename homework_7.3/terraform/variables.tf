variable "token" {
  description = "Default token"
  type = string
  default = "your_token"
}

variable "cloud_id" {
  description = "Default cloud_id"
  type = string
  default = "your_cloud_id"
}

variable "folder_id" {
  description = "Default folder_id"
  type = string
  default = "your_folder_id"
}

variable "zone" {
  description = "Default zone"
  type = string
  default = "ru-central1-a"
}

locals {
  instance_type = {
    stage = "standard-v1"
    prod  = "standard-v2"
  }
}

locals {
  vm_count = {
    stage  = 1
    prod   = 2
  }
}

locals {
  vm_count2 =  [
    {
    instance_type = "standard-v2"
    workspace = "prod"
    },
    {
    instance_type = "standard-v2"
    workspace = "prod"
    },
    {
    instance_type = "standard-v1"
    workspace = "stage"
    }
  ]
}