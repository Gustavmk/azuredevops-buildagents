
variable "resource_group_name" {
  default = "DevOps-PackerResources"
}

variable "resource_group_name_packer" {

}

variable "resource_group_location" {
  default = "eastus"
}

variable "shared_image_gallery_name" {
  default = ""
}


variable "vnet_name" {}

variable "tags" {
  type = map(any)
  default = {
    Environment = "Test"
    Role        = "Azure DevOps"
  }
}

variable "identifier_publisher" {
  default = "drylabs"
}

variable "images" {
  type = map(any)
  default = {
    image = {
      publisher  = ""
      offer      = ""
      sku        = ""
      definition = ""
      osType     = ""
    }
  }
}