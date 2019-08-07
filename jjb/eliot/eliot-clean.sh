#!/bin/bash

set -x

# log info to console
echo "cc"
echo "--------------------------------------------------------"
echo

node_name=$(kubectl get node  |awk '{print $1}' |grep -v NAME) ||true
for i in $node_name;
do
  kubectl drain $i  --delete-local-data --force --ignore-daemonsets
  kubectl delete node  $i
done

if [[ "$NODE_NAME" =~ "huawei-eliot-pod1" ]]; then
    sshpass -f /home/jenkins/pwfile.txt ssh root@10.10.0.99 sudo kubeadm reset -f ||true
    sshpass -f /home/jenkins/pwfile.txt ssh root@10.10.1.15 sudo kubeadm reset -f ||true
elif [[ "$NODE_NAME" =~ "huawei-eliot-centos-pod3" ]]; then
    sshpass -f /home/jenkins/pwfile.txt ssh root@10.10.0.211 sudo kubeadm reset -f ||true
    sshpass -f /home/jenkins/pwfile.txt ssh root@10.10.0.138 sudo kubeadm reset -f ||true

fi

echo
echo "--------------------------------------------------------"
echo "Cleaned"
