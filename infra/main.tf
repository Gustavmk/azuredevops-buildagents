terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = var.tags
}

resource "azurerm_resource_group" "packer_build" {
  name     = var.resource_group_name_packer
  location = var.resource_group_location

  tags = var.tags
}

resource "azurerm_shared_image_gallery" "main" {
  name                = var.shared_image_gallery_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  description = "Shared images and things."

  tags = var.tags
}

module "gallery_images_azure_devops" {
  for_each = var.images

  source                  = "./modules/shared-image"
  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name
  gallery_name            = var.shared_image_gallery_name

  identifier_publisher = each.value["publisher"]
  identifier_offer     = each.value["offer"]
  identifier_sku       = each.value["sku"]
  image_definition     = each.value["definition"]
  os_type              = each.value["osType"]

  depends_on = [azurerm_shared_image_gallery.main]
}

module "virtual-machine" {
  source = "./modules/virtual-machine"


  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  virtual_network_name = module.vnet.vnet_name
  subnet_name          = "subnet1"

  virtual_machine_name = "vmdeployment"


  os_flavor               = "linux"
  linux_distribution_name = "ubuntu2004"
  virtual_machine_size    = "Standard_B2s"
  generate_admin_ssh_key  = true
  instances_count         = 1


  enable_public_ip_address = true

  nsg_inbound_rules = [
    {
      name                   = "ssh"
      destination_port_range = "22"
      source_address_prefix  = "*"
    },
    {
      name                   = "http"
      destination_port_range = "80"
      source_address_prefix  = "*"
    }
  ]

  depends_on = [module.vnet]

}

module "vnet" {
  source              = "./modules/vnet"
  vnet_location       = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  use_for_each        = true
  vnet_name           = var.vnet_name
}


output "private_key" {
  value = module.virtual-machine.admin_ssh_key_private
  sensitive = true
}