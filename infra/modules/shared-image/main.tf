resource "azurerm_shared_image" "main" {
  name                = var.image_definition
  gallery_name        = var.gallery_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  os_type             = var.os_type

  identifier {
    publisher = var.identifier_publisher
    offer     = var.identifier_offer
    sku       = var.identifier_sku
  }
}