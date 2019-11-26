# !/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.                                 #
#                                                                            #
# All rights reserved. This program and the accompanying materials           #
# are made available under the terms of the Apache License, Version 2.0      #
# which accompanies this distribution, and is available at                   #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
##############################################################################

source ../kubeedge/config_kubeedge > /dev/null 2>&1

if [ -d "/etc/kubeedge" ]; then
    sudo rm -rf /etc/kubeedge*
    sudo rm -rf /etc/kubeedge-V1.1.0
    echo "kubeedge folder cleaned"
fi

cd ${PATH_OF_KUBEEDGE}

kubectl delete -f devices_v1alpha1_devicemodel.yaml
kubectl delete -f devices_v1alpha1_device.yaml

echo $(pwd)
sudo kubeadm reset -f
sudo rm -rf /var/lib/etcd

KUBEEDGE_CLEAN="sudo rm -rf /etc/kubeedge*"
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${KUBEEDGE_CLEAN}

