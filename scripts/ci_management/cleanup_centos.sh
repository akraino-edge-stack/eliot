# !/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.                                 #
#                                                                            #
# All rights reserved. This program and the accompanying materials           #
# are made available under the terms of the Apache License, Version 2.0      #
# which accompanies this distribution, and is available at                   #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
##############################################################################

KUBEADM_RESET="sudo kubeadm reset"
ETCD_CLEAN="sudo rm -rf /var/lib/etcd"
DEPLOYMENT_YAML="cd $HOME && kubectl delete -f test-k8snginx.yaml && rm -rf testk8s-nginx.yaml"
CLEANUP_PROM_CADVISOR="cd eliot/scripts/ci_management && ./uninstall_cadvisor.sh"

${KUBEADM_RESET}

if [ -f "$HOME/testk8s-nginx.yaml" ]; then
    ${DEPLOYMENT_YAML}
    echo "testk8s-nginx.yaml cleaned"
fi

if [ -d "/var/lib/etcd" ]; then
    ${ETCD_CLEAN}
    echo "etcd cleaned"
fi

# Read all the Worker Node details from nodelist file.
echo $(pwd)
while read line
do
     nodeinfo="${line}"
     #echo ${nodeinfo}
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     #echo ${nodeip}
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     #echo ${nodepaswd}
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${KUBEADM_RESET}
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${ETCD_CLEAN}
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${CLEANUP_PROM_CADVISOR}
done < nodelist > /dev/null 2>&1

