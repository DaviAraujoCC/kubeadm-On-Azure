resource "azurerm_linux_virtual_machine" "k8s-master" {
  name                = "master"
  resource_group_name = azurerm_resource_group.k8s-group.name
  location            = azurerm_resource_group.k8s-group.location
  size                = var.t_k8s_master
  admin_username      = "master"
  network_interface_ids = [
    azurerm_network_interface.nic-master.id,
  ]
  depends_on = [
    tls_private_key.tls_key,
  ]
  
  admin_ssh_key {
    username   = "master"
    public_key = tls_private_key.tls_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  connection {
    type        = "ssh"
    user        = "master"
    password    = ""
    private_key = tls_private_key.tls_key.private_key_pem
    host        = self.public_ip_address
  }

  provisioner "file" {
    source      = "../scripts/install-docker.sh"
    destination = "/tmp/install-docker.sh"
  }

  provisioner "file" {
    source      = "../scripts/install-kubeadm.sh"
    destination = "/tmp/install-kubeadm.sh"
  }

  provisioner "file" {
    source      = "../scripts/install-master.sh"
    destination = "/tmp/install-master.sh"
  }

  provisioner "file" {
      source = var.private_key_path
      destination = "/home/master/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-*.sh",
      "sudo /bin/bash /tmp/install-docker.sh",
      "sudo /bin/bash /tmp/install-kubeadm.sh",
      "sudo /bin/bash /tmp/install-master.sh ${var.qnt_k8s_nodes} ${self.public_ip_address}",
    ]

  
  }
}



resource "azurerm_linux_virtual_machine" "k8s-worker" {
  name                = "node-${count.index}"
  resource_group_name = azurerm_resource_group.k8s-group.name
  location            = azurerm_resource_group.k8s-group.location
  size                = var.t_k8s_worker
  admin_username      = "node-${count.index}"
  count = var.qnt_k8s_nodes
  network_interface_ids = [
    azurerm_network_interface.nic-worker[count.index].id,
  ]
  depends_on = [
    azurerm_linux_virtual_machine.k8s-master,
  ]
  
  admin_ssh_key {
    username   = "node-${count.index}"
    public_key = tls_private_key.tls_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  connection {
    type        = "ssh"
    user        = "node-${count.index}"
    password    = ""
    private_key = tls_private_key.tls_key.private_key_pem
    host        = self.public_ip_address
  }

  provisioner "file" {
    source      = "../scripts/install-docker.sh"
    destination = "/tmp/install-docker.sh"
  }

  provisioner "file" {
    source      = "../scripts/install-kubeadm.sh"
    destination = "/tmp/install-kubeadm.sh"
  }

  provisioner "file" {
      source = var.private_key_path
      destination = "/tmp/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-*.sh",
      "sudo /bin/bash /tmp/install-docker.sh",
      "sudo /bin/bash /tmp/install-kubeadm.sh",
      "sudo ssh -oStrictHostKeyChecking=no -i /tmp/id_rsa master@${azurerm_linux_virtual_machine.k8s-master.private_ip_address} \"cat /tmp/cmd_join\" | sudo sh ",
    ]

  
  }

}

