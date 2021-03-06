#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.                                 #
#                                                                            #
# All rights reserved. This program and the accompanying materials           #
# are made available under the terms of the Apache License, Version 2.0      #
# which accompanies this distribution, and is available at                   #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
##############################################################################

# constants

POD_NETWORK_CIDR=192.168.0.0/16
KUBE_VERSION=1.17.2-0
KUBERNETES_CNI=0.7.5-0

# start

hostname -I > hostname.tmp
MASTER_IP="$(cut -d ' ' -f 1 hostname.tmp)"
rm hostname.tmp

# kubernetes installation

sudo yum install -y kubelet-${KUBE_VERSION} kubectl-${KUBE_VERSION} \
kubernetes-cni-${KUBERNETES_CNI}

sudo systemctl daemon-reload
sudo systemctl restart kubelet

# Initialize kubernetes on master

sudo kubeadm init \
	--apiserver-advertise-address="${MASTER_IP}" \
	--pod-network-cidr="${POD_NETWORK_CIDR}"

mkdir -p "${HOME}/.kube"
sudo cp -i /etc/kubernetes/admin.conf "${HOME}/.kube/config"
sudo chown "$(id -u)":"$(id -g)" "${HOME}/.kube/config"
