//Network security groups rules, set ssh and nodeport default pool to be accessed from external

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg01"
  location            = azurerm_resource_group.k8s-group.location
  resource_group_name = azurerm_resource_group.k8s-group.name
  
  security_rule {
    name                       = "k8s-svc"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "30000-32000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${chomp(data.http.local_ip.body)}"
    destination_address_prefix = "*"
  }
security_rule {
    name                       = "tls-local"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges     = ["6443","443"]
    source_address_prefixes      = ["${chomp(data.http.local_ip.body)}"]
    destination_address_prefix = "*"

}
security_rule {
    name                       = "tls-whitelist"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["6443","443"]
    source_address_prefixes    = var.ip_whitelist
    destination_address_prefix = "*"

}
}