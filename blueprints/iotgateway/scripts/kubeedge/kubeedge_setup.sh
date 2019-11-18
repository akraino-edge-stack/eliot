#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# constants

VERSION="v1.1.0"
OS="linux"
ARCH="amd64"

PATH_OF_EDGECORE="cd /etc/kubeedge-v1.1.0-linux-amd64/edge/ && sudo ./edgecore"

initialize_k8s_cluster()
{
   ../setup.sh
}

kubeedge_tar_untar()
{

   curl -L \ 
   "https://github.com/kubeedge/kubeedge/releases/download/${VERSION}/kubeedge-${VERSION}-${OS}-${ARCH}.tar.gz" \
   --output kubeedge-${VERSION}-${OS}-${ARCH}.tar.gz \
   && sudo tar -xf kubeedge-${VERSION}-${OS}-${ARCH}.tar.gz  -C /etc

}

generate_certs()
{

   wget -L https://raw.githubusercontent.com/kubeedge/kubeedge/master/build/tools/certgen.sh

   chmod +x certgen.sh
   bash -x ./certgen.sh genCertAndKey edge

}

initialize_yaml()
{

   wget -L https://raw.githubusercontent.com/kubeedge/kubeedge/master/build/crds/devices/devices_v1alpha1_devicemodel.yaml

   chmod +x devices_v1alpha1_devicemodel.yaml

   kubectl create -f devices_v1alpha1_devicemodel.yaml

   wget -L https://raw.githubusercontent.com/kubeedge/kubeedge/master/build/crds/devices/devices_v1alpha1_device.yaml

   chmod +x devices_v1alpha1_device.yaml
   kubectl create -f devices_v1alpha1_device.yaml

}

# Run cloudcore

cloudcore_start()
{

   cd /etc/kubeedge-${VERSION}-${OS}-${ARCH}/cloud/cloudcore
   sudo ./cloudcore

}


exec_edge()
{
    cd $PATH_OF_IOTGATEWAY/scripts/kubeedge

    source ./config_kubeedge

    sshpass -p ${EDGENODEPASSWORD} \
    scp $PATH_OF_IOTGATEWAY/scripts/kubeedge/config_kubeedge \
    ${EDGENODEUSR}@${EDGENODEIP}:$HOME_EDGENODE

    sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} \
    source config_kubeedge

    sshpass -p ${EDGENODEPASSWORD} \
    scp -r $KUBEEDGE_ETC \
    ${EDGENODEUSR}@${EDGENODEIP}:/etc

    sshpass -p ${EDGENODEPASSWORD} \
    scp -r $KUBEEDGE_VERSION_ETC \
    ${EDGENODEUSR}@${EDGENODEIP}:/etc

    sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} \
    $PATH_OF_EDGECORE
}

apply_node_json()
{
   kubectl apply -f node.json
}



# start

initialize_k8s_cluster

kubeedge_tar_untar

generate_certs

initialize_yaml

cloudcore_start

exec_edge > /dev/null 2>&1

apply_node_json
