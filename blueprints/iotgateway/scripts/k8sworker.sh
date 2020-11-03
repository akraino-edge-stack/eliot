#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

KUBE_VERSION=1.17.2-00
K8S_CNI_VERSION=0.7.5-00

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
  kubeadm=${KUBE_VERSION} kubelet=${KUBE_VERSION} kubernetes-cni=${K8S_CNI_VERSION}

#sudo apt-mark hold kubelet kubeadm
