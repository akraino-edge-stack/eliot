#!/bin/bash -ex
#
# The script is to setup the ELIOT Manager and ELIOT nodes.
# It installs Docker in both ELIOT Manager and ELIOT node.
# It installs Kubernetes. In the ELIOT Manager kubeadm, kubelet, kubectl is installed.
# In ELIOT Edge Node it will install kubelet only.
#
#

usage() {

  echo "Usage: $0 execute without any parameter."
  echo "Before executing re-check the entries in file nodelist."
  echo "Nodelist file should have the details of Worker Nodes in the format of username|IP|password"
  echo "The script has to be executed in the Master Node"

}

setup_k8smaster()
{
  set -o xtrace
  source common.sh | tee eliotcommon.log
  source k8smaster.sh | tee kubeadm.log
  KUBEADM_JOIN=$(grep "kubeadm join " ./kubeadm.log)
  KUBEADM_JOIN="sudo"+${KUBEADM_JOIN}
  setup_k8sworkers
}

setup_k8sworkers()
{
  set -o xtrace

  SETUP_WORKER_COMMON="cd eliot/scripts && source common.sh"
  SETUP_WORKER="cd eliot/scripts/ && source k8sworker.sh"

  KUBEADM_JOIN=$(grep "kubeadm join " ./kubeadm.log)
  KUBEADM_JOIN="sudo ${KUBEADM_JOIN}"

#Read all the Worker Node details from nodelist file.
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

if [ $# -gt 0 ]
then
  usage
  exit 0
fi

setup_k8smaster
