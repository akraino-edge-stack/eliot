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

DOCKER_VERSION=18.09.6
KUBE_VERSION=1.15.0-0
MACHINE=$(uname -m)

# start

# This script will install docker, kubeadm on both Eliot Master and Edge nodes

sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' \
/etc/sysconfig/selinux

sudo modprobe br_netfilter
_conf='/etc/sysctl.d/99-akraino-eliot.conf'
echo 'net.bridge.bridge-nf-call-iptables = 1' |& sudo tee "${_conf}"
sudo sysctl -q -p "${_conf}"

#echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

swapoff -a

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager \
--add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce-${DOCKER_VERSION} docker-ce-cli-${DOCKER_VERSION} \
containerd.io

# Kubernetes repository set

cat <<-EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-${MACHINE}
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo yum install -y kubeadm-${KUBE_VERSION}
sudo systemctl start docker && sudo systemctl enable docker

sudo systemctl daemon-reload
