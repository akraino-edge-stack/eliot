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
  set -o xtrace
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

  KUBEADM_JOIN=$(grep "kubeadm join " ./kubeadm.log)
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
 done < nodelist

}


# Start
#

if [ $1 == "--help" ] || [ $1 == "-h" ];
then
  show_help
  exit 0
fi


setup_k8smaster
