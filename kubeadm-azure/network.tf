
resource "azurerm_virtual_network" "vn01" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.k8s-group.location
  resource_group_name = azurerm_resource_group.k8s-group.name
}



resource "azurerm_subnet" "subnet01" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.k8s-group.name
  virtual_network_name = azurerm_virtual_network.vn01.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_public_ip" "publicip-master" {
  name                    = "pip-master"
  location                = azurerm_resource_group.k8s-group.location
  resource_group_name     = azurerm_resource_group.k8s-group.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

resource "azurerm_public_ip" "publicip-worker" {
  name                    = "pip-master-${count.index}"
  location                = azurerm_resource_group.k8s-group.location
  resource_group_name     = azurerm_resource_group.k8s-group.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  count = var.qnt_k8s_nodes
}



resource "azurerm_subnet_network_security_group_association" "nsg-asc" {
  subnet_id                 = azurerm_subnet.subnet01.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface" "nic-master" {
  name                = "nic-master"
  location            = azurerm_resource_group.k8s-group.location
  resource_group_name = azurerm_resource_group.k8s-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip-master.id
  }
}



resource "azurerm_network_interface" "nic-worker" {
  name                = "nic-worker-${count.index}"
  location            = azurerm_resource_group.k8s-group.location
  resource_group_name = azurerm_resource_group.k8s-group.name
  count = var.qnt_k8s_nodes

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip-worker[count.index].id
  }
}