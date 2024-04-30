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
  name     = "rg-temp-packer2024"
  location = var.resource_group_location

  tags = var.tags
}


resource "azurerm_shared_image_gallery" "main" {
  name                = var.shared_image_gallery_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  description         = "Shared images and things."

  tags = var.tags
}

module "ubuntu2004-agentpool-full" {
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
  source  = "./modules/virtual-machine"


  resource_group_name  =  azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  virtual_network_name = module.vnet.vnet_name
  subnet_name          = module.vnet.vnet_subnets[0]
  virtual_machine_name = "vmdeployment"


  os_flavor               = "linux"
  linux_distribution_name = "ubuntu2204"
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

  enable_boot_diagnostics = false

  deploy_log_analytics_agent = false

}

module "vnet" {
  source              = "./modules/vnet"
  vnet_location       = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  use_for_each        = true
}