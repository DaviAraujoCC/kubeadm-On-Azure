#!/bin/bash

#Instalação do docker

curl https://releases.rancher.com/install-docker/19.03.sh | sh


#Correção erro versão alpha
sudo sed -i 's/sock$/sock --exec-opt native.cgroupdriver=systemd/g' /lib/systemd/system/docker.service

sudo systemctl daemon-reload
sudo systemctl restart docker