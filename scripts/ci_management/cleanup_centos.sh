# !/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.                                 #
#                                                                            #
# All rights reserved. This program and the accompanying materials           #
# are made available under the terms of the Apache License, Version 2.0      #
# which accompanies this distribution, and is available at                   #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
##############################################################################

sudo kubeadm reset

if [ -f "$HOME/testk8s-nginx.yaml" ]; then
    cd $HOME && kubectl delete -f test-k8snginx.yaml && rm -rf testk8s-nginx.yaml
    echo "testk8s-nginx.yaml cleaned"
fi

if [ -d "/var/lib/etcd" ]; then
    sudo rm -rf /var/lib/etcd
    echo "etcd cleaned"
fi

KUBEADM_RESET="sudo kubeadm reset"
ETCD_CLEAN="sudo rm -rf /var/lib/etcd"
CLEANUP_PROM_CADVISOR="cd eliot/scripts/ci_management && ./uninstall_cadvisor.sh"

# Read all the Worker Node details from nodelist file.
echo $(pwd)
while read line
do
     nodeinfo="${line}"
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${KUBEADM_RESET}
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${ETCD_CLEAN}
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${CLEANUP_PROM_CADVISOR}
done < nodelist > /dev/null 2>&1

