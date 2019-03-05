#!/bin/bash -ex
KUBE_VERSION=1.13.0-00
POD_NETWORK_CIDR=192.168.0.0/16

# Install Kubernetes with Kubeadm

# Disable swap 
sudo swapoff -a
sudo apt update
sudo apt install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt update
sudo apt install -y \
  kubelet=${KUBE_VERSION} kubeadm=${KUBE_VERSION} kubectl=${KUBE_VERSION}

sudo apt-mark hold kubelet kubeadm kubectl

if ! kubectl get nodes; then
  hostname -I > hostname.tmp
  MASTER_IP="$(cut -d ' ' -f 1 hostname.tmp)"
  rm hostname.tmp
  sudo kubeadm config images pull
  sudo kubeadm init \
	 --apiserver-advertise-address="${MASTER_IP}" \
	 --pod-network-cidr="${POD_NETWORK_CIDR}"

  if [ "$(id -u)" = 0 ]; then
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" | \
      tee -a "${HOME}/.profile"
    source "${HOME}/.profile"
  else
    mkdir -p "${HOME}/.kube"
    sudo cp -i /etc/kubernetes/admin.conf "${HOME}/.kube/config"
    sudo chown "$(id -u)":"$(id -g)" "${HOME}/.kube/config"
  fi
  kubectl apply -f "cni/calico/rbac.yaml"
  kubectl apply -f "cni/calico/calico.yaml"

fi
