#!/bin/bash

set -x

# log info to console
echo "Cleaning up environment"
echo "--------------------------------------------------------"
echo

rm -rf $WORKSPACE/scripts/src/nodelist
cp /home/jenkins/nodelist_kubeedge $WORKSPACE/scripts/src/nodelist

rm -rf  /root/go/src/github.com/kubeedge/kubeedge

cd $WORKSPACE/ci_management
./cleanup.sh

node_name=$(kubectl get node  |awk '{print $1}' |grep -v NAME) ||true
for i in $node_name;
do
  kubectl drain $i  --delete-local-data --force --ignore-daemonsets
  kubectl delete node  $i
done

sshpass  ssh root@10.10.0.54 sudo kubeadm reset -f ||true
sshpass  ssh root@10.10.0.45 sudo kubeadm reset -f ||true

echo
echo "--------------------------------------------------------"
echo "Cleaned"

