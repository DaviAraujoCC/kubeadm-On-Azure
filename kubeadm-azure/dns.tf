resource "azurerm_private_dns_zone" "k8s-zone" {
  name                = "k8s.local"
  resource_group_name = azurerm_resource_group.k8s-group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet-dns" {
  name                  = "vnet-dns-asc"
  resource_group_name   = azurerm_resource_group.k8s-group.name
  private_dns_zone_name = azurerm_private_dns_zone.k8s-zone.name
  virtual_network_id    = azurerm_virtual_network.vn01.id
  depends_on = [
    azurerm_virtual_network.vn01,
    azurerm_private_dns_zone.k8s-zone
  ]
}

resource "azurerm_private_dns_a_record" "master-record" {
  name                = "master"
  zone_name           = azurerm_private_dns_zone.k8s-zone.name
  resource_group_name = azurerm_resource_group.k8s-group.name
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine.k8s-master.private_ip_address]
  depends_on = [
    azurerm_linux_virtual_machine.k8s-master
  ]
}

resource "azurerm_private_dns_a_record" "worker-record" {
  name                = "node-${count.index}"
  zone_name           = azurerm_private_dns_zone.k8s-zone.name
  resource_group_name = azurerm_resource_group.k8s-group.name
  count = var.qnt_k8s_nodes
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine.k8s-worker[count.index].private_ip_address]
  depends_on = [
    azurerm_linux_virtual_machine.k8s-worker
  ]
}