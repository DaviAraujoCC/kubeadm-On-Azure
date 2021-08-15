#!/bin/bash

#Docker installation

curl https://releases.rancher.com/install-docker/19.03.sh | sh


#Alpha version kubeadm correction
sudo sed -i 's/sock$/sock --exec-opt native.cgroupdriver=systemd/g' /lib/systemd/system/docker.service

sudo systemctl daemon-reload
sudo systemctl restart docker

#