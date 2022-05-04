#!/bin/sh
sudo systemctl unmask docker
sudo apt remove docker
sudo apt install docker docker-ce
sudo dockerd
service docker start
sudo systemctl status docker
sudo kubeadm reset
sudo rm -rf /etc/cni/net.d/
sudo rm -rf /root/.kube/config
# then, it should be ready for kubeadm init
# maybe , you should try kubectl apply -f calico.yaml
