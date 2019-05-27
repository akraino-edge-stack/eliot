#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

take_keedge(){

   git clone https://github.com/kubeedge/kubeedge.git $GOPATH/src/github.com/kubeedge/kubeedge
   cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm
   make

}

common_steps="git clone https://github.com/kubeedge/kubeedge.git $GOPATH/src/github.com/kubeedge/kubeedge &&\
cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm &&\
make &&\
chmod +x kubeedge"

certif_copy="cd /etc/kubeedge &&\
scp certs.tar.gz"

edge_start="kubeedge join --edgecontrollerip=${nodeip} --edgenodeid=eliot_edge_01"

execute_keedge_controller(){
   cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm
   sudo chmod +x kubeedge
   ./kubeedge init
}


# start

take_keedge

execute_keedge_controller

while read line
do
    nodeinfo="${line}"
    nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
    nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
    nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
    masternodeip=$(echo ${nodeinfo} | cut -d"|" -f3)

    sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${common_steps} < /dev/null
    sshpass -p ${nodepaswd} scp /etc/kubeedge/certs.tar.gz ${nodeusr}@${nodepaswd}:/etc/kubeedge

    sshpass -p ${nodepaswd} \
    tar -xvzf /etc/kubeedge/certs.tgz

    sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} kubeedge join --edgecontrollerip=${masternodeip} --edgenodeid=eliot_edge_01 \
    --k8sserverip=${masternodeip}:8080
done < nodelist

kubectl get nodes

kubectl create -f deployment.yaml

kubectl get pods
