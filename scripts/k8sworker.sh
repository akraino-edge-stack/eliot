#!/bin/bash -ex
KUBE_VERSION=1.13.0-00
# Install Kubernetes with Kubeadm
# The script will be executed in Eliot Edge Node

sudo swapoff -a
sudo apt update
sudo apt install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt update
sudo apt install -y \
  kubeadm=${KUBE_VERSION} kubelet=${KUBE_VERSION}

sudo apt-mark hold kubelet kubeadm
