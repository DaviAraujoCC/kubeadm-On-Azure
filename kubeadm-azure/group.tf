resource "azurerm_resource_group" "k8s-group" {
  name     = var.k8s_group_name
  location = var.region_name
}