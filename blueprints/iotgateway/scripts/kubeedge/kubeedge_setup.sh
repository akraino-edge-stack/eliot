#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

echo "**********************************************************************"
echo "Kubeedge-v1.1.0 Installation------------------------------------------STARTED"

# constants

VERSION="v1.1.0"
OS="linux"
ARCH="amd64"

PATH_OF_EDGECORE="/etc/kubeedge-v1.1.0-linux-amd64/edge/edgecore"

initialize_k8s_cluster()
{
   #cd ../
   #./setup.sh
   cp /etc/kubernetes/admin.conf /root/.kube/config
   #source common.sh
   #source k8smaster.sh
}

kubeedge_tar_untar()
{

   curl -L "https://github.com/kubeedge/kubeedge/releases/download/${VERSION}/kubeedge-${VERSION}-${OS}-${ARCH}.tar.gz" \
   --output kubeedge-${VERSION}-${OS}-${ARCH}.tar.gz && sudo tar -xf kubeedge-${VERSION}-${OS}-${ARCH}.tar.gz  -C /etc

}

generate_certs()
{
   echo "generate_certs started"
   wget -L https://raw.githubusercontent.com/kubeedge/kubeedge/master/build/tools/certgen.sh

   chmod +x certgen.sh
   bash -x ./certgen.sh genCertAndKey edge

   echo "generate_certs ended"

}

initialize_yaml()
{
   echo "initalize_yaml started"
   wget -L https://raw.githubusercontent.com/kubeedge/kubeedge/master/build/crds/devices/devices_v1alpha1_devicemodel.yaml

   chmod +x devices_v1alpha1_devicemodel.yaml

   kubectl create -f devices_v1alpha1_devicemodel.yaml

   wget -L https://raw.githubusercontent.com/kubeedge/kubeedge/master/build/crds/devices/devices_v1alpha1_device.yaml

   chmod +x devices_v1alpha1_device.yaml
   kubectl create -f devices_v1alpha1_device.yaml
   echo "initialize_yaml ended"
}

# Run cloudcore

cloudcore_start()
{
   echo "cloudcore_start started"
   cp controller.yaml /etc/kubeedge-${VERSION}-${OS}-${ARCH}/cloud/cloudcore/conf/controller.yaml
   cd /etc/kubeedge-${VERSION}-${OS}-${ARCH}/cloud/cloudcore
   nohup ./cloudcore > cloudcore.log 2>&1 &
   echo "cloudcore_start ended"
}

edge_modify()
{
   sed "s/0.0.0.0/${MASTERNODEIP}/" /etc/kubeedge-${VERSION}-${OS}-${ARCH}/edge/conf/edge.yaml > /etc/kubeedge-${VERSION}-${OS}-${ARCH}/edge/conf/edge_new.yaml
   #rm -rf /etc/kubeedge-${VERSION}-${OS}-${ARCH}/edge/conf/edge.yaml
   mv /etc/kubeedge-${VERSION}-${OS}-${ARCH}/edge/conf/edge_new.yaml /etc/kubeedge-${VERSION}-${OS}-${ARCH}/edge/conf/edge.yaml

}

exec_edge()
{
    echo "exec_edge started"

    sshpass -p ${EDGENODEPASSWORD} \
    scp -r $KUBEEDGE_ETC \
    ${EDGENODEUSR}@${EDGENODEIP}:/etc

    sshpass -p ${EDGENODEPASSWORD} \
    scp -r $KUBEEDGE_VERSION_ETC \
    ${EDGENODEUSR}@${EDGENODEIP}:/etc

    sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} \
    nohup $PATH_OF_EDGECORE > edgecore.log 2>&1 &
    echo "exec_edge ended"
}

apply_node_json()
{
   echo "apply_node_json started"
   echo $(pwd)
   cd ${PATH_OF_KUBEEDGE}
   kubectl apply -f node.json
   echo "apply_node_json ended"
}



# start
source config_kubeedge
initialize_k8s_cluster

# sleep added for k8s kube-system pods to be up

#sleep 240

kubeedge_tar_untar

generate_certs

initialize_yaml

cloudcore_start
edge_modify
exec_edge > /dev/null 2>&1

apply_node_json

echo "Kubeedge-v1.1.0 Installation------------------------------------------SUCCESS"
echo "************************************************************************"
