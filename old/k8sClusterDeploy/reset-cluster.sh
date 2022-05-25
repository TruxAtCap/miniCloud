!#/bin/bash

sudo kubeadm reset
sudo rm -rf /etc/cni/net.d /home/kube/.kube/config
sudo systemctl stop kubelet
