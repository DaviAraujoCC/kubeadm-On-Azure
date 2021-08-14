
output "master_public_ip_k8s" {
    value = azurerm_linux_virtual_machine.k8s-master.public_ip_address
}

output "node_public_ip_k8s" {
    value = azurerm_linux_virtual_machine.k8s-worker[*].public_ip_address
}