## Kubeadm On Azure

![image](https://user-images.githubusercontent.com/70732391/129459081-0bc31093-d0fb-41fa-b2b7-e53d7ef2ba70.png)


This is a simple project in terraform made by me while studying for CKA, it just create a basic k8s cluster with one master node  and x worker nodes using kubeadm utility in azure environment.

For whom want to make a basic lab for study and already knows how to build one, this is a way-to-go.



## Before you begin

* I configured <b>client secret for service principal</b> as default, you can use the terraform.tfvars to inform the credentials, but if you want change this method just access main.tf and make the adjusts, please refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
* This solution uses <b> weave CNI </b> as default.
* Authentication for ssh to nodes are made by public/private keys (openssh) but you don't need to create, since terraform will create for you in <b>certs</b> directory (local).
* Your external ip is whitelisted automatically but if you want to access it in other regions you need to specify this in var <b>ip_whitelist</b>

## Techs:

- Kubeadm 
- Terraform
- Azure
- Kubernetes
- Docker

## Usage: 

1. Modify the <b>terraform.tfvars</b> file with your credentials/values, as you like.

2. Use ````terraform init```` to download plugins/modules

3. After finishing first step you can use ````terraform plan```` to check if everything is fine
4. Run ````terraform apply```` to create your cluster and check for output (````terraform output````)
5. Use the private key created in certs folder to access your master node ````ssh -i certs/privkey.pem master@MASTER-EXTERNAL-IP ````
6. (Optional) If you want to run your cluster command in your machine copy the kubeconfig file in master (/etc/kubernetes/admin.conf) and change the server from local-ip to external-ip ````scp master@MASTER-EXTERNAL-IP:/etc/kubernetes/admin.conf ~/.kube/config````
7. Run a command to check of nodes are ready ````kubectl get nodes```` , ````kubectl run nginx --image=nginx ; kubectl get pods -w````
