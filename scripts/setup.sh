#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

########################################################################################
#                                                                                      #
# The script is to setup the ELIOT Manager and ELIOT nodes.                            #
# It installs Docker in both ELIOT Manager and ELIOT node.                             #
# It installs Kubernetes. In the ELIOT Manager kubeadm, kubelet, kubectl is installed. #
# In ELIOT Edge Node it will install kubeadn, kubelet.                                 #
# Script is tested in Ubuntu 16.04 version.                                            #
# sshpass needs to be installed before executing this script.                          #
########################################################################################

# constants

OSPLATFORM=$(awk -F= '/^NAME/{print $2}' /etc/os-release)


show_help()
{
  echo "The script helps in setting up the ELIOT Toplogy Infrastrucutre"
  echo "The setup installs Docker, K8S Master and K8S worker nodes in  "
  echo "ELIOT Manager and ELIOT Workder Nodes respectively "
  echo "After completion of script execution execute command: "
  echo "kubectl get nodes to check whether the connection between "
  echo "ELIOT Manager and ELIOT Nodes are established"
  echo ""
  echo "Nodelist file should have the details of Worker Nodes in the format of:"
  echo "EliotNodeUserName|EliotNodeIP|EliotNodePasswor"
  echo "Each line should have detail of one ELIOT Node only"
}

# Setting up ELIOT Manager Node.
# Installing Docker, K8S and Initializing K8S Master
setup_k8smaster()
{
  #set -o xtrace
  sudo rm -rf ~/.kube
  source common.sh | tee eliotcommon.log
  source k8smaster.sh | tee kubeadm.log
  # Setup ELIOT Node
  setup_k8sworkers
}

setup_k8sworkers()
{
  set -o xtrace

  # Install Docker on ELIOT Node
  ELIOT_REPO="https://gerrit.akraino.org/r/eliot"
  SETUP_WORKER_COMMON="sudo rm -rf ~/eliot &&\
                       git clone ${ELIOT_REPO} &&\
                       cd eliot/scripts && source common.sh"
  #SETUP_WORKER_COMMON="cd eliot/scripts && source common.sh"
  SETUP_WORKER="cd eliot/scripts/ && source k8sworker.sh"

  KUBEADM_JOIN=$(grep "kubeadm join" ./kubeadm.log)
  KUBEADM_JOIN="sudo ${KUBEADM_JOIN}"

 # Read all the Worker Node details from nodelist file.
 while read line
 do
     nodeinfo="${line}"
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${SETUP_WORKER_COMMON} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${SETUP_WORKER} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${KUBEADM_JOIN} < /dev/null
 done < nodelist > /dev/null 2>&1

}

setup_k8smaster_centos()
{
  set -o xtrace
  sudo rm -rf ~/.kube
  source common_centos.sh | tee eliotcommon_centos.log
  source k8smaster_centos.sh | tee kubeadm_centos.log

  # Setup ELIOT Node
  setup_k8sworkers_centos

  cd cni/calico
  kubectl apply -f rbac.yaml
  kubectl apply -f calico.yaml
}


setup_k8sworkers_centos()
{
  set -o xtrace
  # Install Docker on ELIOT Node

  ELIOT_REPO="https://gerrit.akraino.org/r/eliot"
  SETUP_WORKER_COMMON_CENTOS="sudo rm -rf ~/eliot &&\
                              git clone ${ELIOT_REPO} &&\
                              cd eliot/scripts && source common_centos.sh"

  KUBEADM_TOKEN=$(sudo kubeadm token create --print-join-command)
  KUBEADM_JOIN_CENTOS="sudo ${KUBEADM_TOKEN}"

 # Read all the Worker Node details from nodelist file.
 while read line
 do
     nodeinfo="${line}"
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${SETUP_WORKER_COMMON_CENTOS} < /dev/null
     #sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${SETUP_WORKER_CENTOS} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${KUBEADM_JOIN_CENTOS} < /dev/null
 done < nodelist

}

#verify kubernetes setup by deploying nginx server.

verify_k8s_status(){
  set -o xtrace
  source verifyk8s.sh | tee verifyk8s.log
}

install_cadvisor_edge(){
 set -o xtrace
 SETUP_CADVISOR_ATEDGE="cd eliot/scripts/ && source cadvisorsetup.sh" 
 while read line
 do
     nodeinfo="${line}"
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${SETUP_CADVISOR_ATEDGE} < /dev/null
 done < nodelist > /dev/null 2>&1
}

install_prometheus(){
set -o xtrace
source prometheus.sh | tee install_prometheus.log
}

# Start
#

if [ $1 == "--help" ] || [ $1 == "-h" ];
then
  show_help
  exit 0
fi

if [[ $OSPLATFORM = *CentOS* ]]; then
   setup_k8smaster_centos
else
   setup_k8smaster
fi

sleep 20
verify_k8s_status
install_cadvisor_edge
sleep 10
install_prometheus
sleep 5
sudo docker ps | grep prometheus
