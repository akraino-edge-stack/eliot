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

echo "**********************************************************************"
echo "ELIOT IOT-Gateway Platform Deployment--------------------------STARTED"

# constants

OSPLATFORM=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
ELIOT_REPO="https://gerrit.akraino.org/r/eliot"

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
  SETUP_WORKER_COMMON="sudo rm -rf ~/eliot &&\
                       git clone ${ELIOT_REPO} &&\
                       cd eliot/blueprints/iotgateway/scripts/ && source common.sh"
  #SETUP_WORKER_COMMON="cd eliot/scripts/ && source common.sh"
  SETUP_WORKER="cd eliot/blueprints/iotgateway/scripts/ && source k8sworker.sh"

  KUBEADM_TOKEN=$(kubeadm token create --print-join-command)
  KUBEADM_JOIN="sudo ${KUBEADM_TOKEN}"

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

  kubectl apply -f cni/calico/v38/calico.yaml

}


setup_k8sworkers_centos()
{
  set -o xtrace
  # Install Docker on ELIOT Node

  SETUP_WORKER_COMMON_CENTOS="sudo rm -rf ~/eliot &&\
                              git clone ${ELIOT_REPO} &&\
                              cd eliot/blueprints/iotgateway/scripts/ && source common_centos.sh"

  # SETUP_WORKER_COMMON_CENTOS="cd /root/eliot/scripts/ && source common_centos.sh"

  KUBEADM_TOKEN=$(sudo kubeadm token create --print-join-command)
  KUBEADM_JOIN_CENTOS="sudo ${KUBEADM_TOKEN}"
  # Read all the Worker Node details from nodelist file.
  while read line
  do
      nodeinfo="${line}" < /dev/null 2>&1
      nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1) < /dev/null
      nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)  < /dev/null
      nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3) < /dev/null
      sudo sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${SETUP_WORKER_COMMON_CENTOS} < /dev/null
      sudo sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${KUBEADM_JOIN_CENTOS} < /dev/null
  done < nodelist > /dev/null 2>&1

}

# verify kubernetes setup by deploying nginx server.

verify_k8s_status(){
  set -o xtrace
  source verifyk8s.sh | tee verifyk8s.log
}


install_edgex(){
 set -o xtrace
 cd edgex && source edgexonk8s.sh
}

# verify installation of edgex platform 
verify_edgex()
{
 set -o xtrace
 source verifyedgex.sh | tee verifyedgex.log

}


install_cadvisor_edge(){
 set -o xtrace
 SETUP_CADVISOR_ATEDGE="cd eliot/blueprints/iotgateway/scripts/ && source cadvisorsetup.sh"
 while read line
 do
     nodeinfo="${line}"
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${SETUP_CADVISOR_ATEDGE} < /dev/null
 done < nodelist > /dev/null 2>&1
 echo "CADVISOR Installed in all the ELIOT IOT-GATEWAY Nodes"
}

install_prometheus(){
 set -o xtrace
 source prometheus.sh | tee install_prometheus.log
 echo "Prometheus deployed successfully on ELIOT Manager Node  and integrated with CAdvisor running on IOT-Gateway Nodes "
}

install_opcua_centos(){
 set -o xtrace
 INSTALL_OPCUA_ATEDGE="cd eliot/blueprints/iotgateway/scripts/opc-ua/ && source install.sh"
 while read line
 do
     nodeinfo="${line}"
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${INSTALL_OPCUA_ATEDGE} < /dev/null
 done < nodelist > /dev/null 2>&1
 echo " OPC-UA Server and Client are successfully Deployed on all IOT-Gateway Nodes"
}

# Start
#

if [ $1 == "--help" ] || [ $1 == "-h" ];
then
  show_help
  exit 0
fi

setupPath=`pwd`

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

install_edgex
sleep 20
verify_edgex


# Installing hawkbit through docker container
sudo docker run -p 8080:8080 hawkbit/hawkbit-update-server:latest

# Installing OPC-UA on IOT Gateway Node

cd ${setupPath}
if [[ $OSPLATFORM = *CentOS* ]]; then
   install_opcua_centos
fi

# Removing the taint from master node
kubectl taint nodes --all node-role.kubernetes.io/master- || true

echo "**********************************************************************"
echo "ELIOT IOT-Gateway Platform Deployment--------------------------SUCCESS"

