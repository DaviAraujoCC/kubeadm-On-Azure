// Replace variables

// Credentials  
azure_subscription_id = "xxxxxxxxxxxx"

azure_client_id = "xxxxxxxxxx"

azure_client_secret = "xxxxxxxxxxx"

azure_tenant_id = "xxxxxxxxxxxxxxxxx"

// Worker nodes quantity
qnt_k8s_nodes = "1"

// Size/tier of master
t_k8s_master = "Standard_B2s"

// Size/tier of nodes
t_k8s_worker = "Standard_B2s"

// Vnet name
vnet_name = "vnet01"

// Resource group name
k8s_group_name = "k8s"

// Region name 
region_name = "East US"

// Private key path (default)
private_key_path = "certs/privkey.pem"

// Whitelist ips to access cluster in 443/6443
ip_whitelist = ["1.2.3.4"]