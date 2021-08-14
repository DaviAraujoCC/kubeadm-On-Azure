#!/bin/bash

#Private key to access cluster
sudo chown master:master /home/master/.ssh/id_rsa
sudo chmod 600 /home/master/.ssh/id_rsa

#Create alias ssh_config
for i in `seq 0 $(($1-1))`; do
  echo "Host node-$i" >> /home/master/.ssh/config
  echo "     User node-$i" >> /home/master/.ssh/config
  echo "" >> /home/master/.ssh/config
done

# Init kubeadm default settings
echo y | sudo kubeadm init --apiserver-cert-extra-sans=$2
sudo kubeadm token create --print-join-command > /tmp/cmd_join

#Kubeconfig
mkdir -p /home/master/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/master/.kube/config
sudo chown master:master /home/master/.kube/config


#CNI installation
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
