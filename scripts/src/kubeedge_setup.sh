#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

#Constants
KUBEEDGE_SRC="$GOPATH/src/github.com/kubeedge/kubeedge"
KUBEEDGE_BIN="$GOPATH/src/github.com/kubeedge/kubeedge/keadm"
VERIFY_K8S="$PATH_OF_ELIOTFOLDER/scripts/verifyk8s.sh"

{ set +x; } > /dev/null 2>&1

if [ -n "$1" ]; then

if [ "$1" != "--help" ]; then
    echo ""
    echo "Usage of the command is wrong.. Please type ./kubeedge_setup.sh --help for more details"
    echo ""
    exit 0
fi

fi

if [ "$1" == "--help" ]; then
    echo ""
    echo "This script will setup the kubeedge installation on Eliot master and Eliot edge"
    echo "Before Executing this, add Eliot master and Eliot edge details in config_kubeedge file"
    echo ""
    exit 0; set -x;
fi

# take_keedge will download the source code of kubeedge in master and in edge

take_keedge(){

    source ~/.profile
    git clone https://github.com/kubeedge/kubeedge.git \
    $KUBEEDGE_SRC
    cd $KUBEEDGE_BIN
    make
}

source config_kubeedge > /dev/null 2>&1

common_steps="echo $GOPATH && \
git clone https://github.com/kubeedge/kubeedge.git $KUBEEDGE_SRC && \
source ~/.profile && \
cd $GOPATH/src && \
sudo chmod -R 777 github.com && \
cd $KUBEEDGE_BIN && \
make"

edge_start="cd $KUBEEDGE_BIN && \
sudo chmod +x keadm && \
sudo ./keadm join --edgecontrollerip=$MASTERNODEIP --edgenodeid=$EDGENODEID \
--k8sserverip=$MASTERNODEIP:8080"

# Initialisation of ELIOT master with kubeedge

execute_keedge_controller(){
    cd $KUBEEDGE_BIN
    sudo chmod +x keadm
    sudo ./keadm init
}

# Initialisation of Eliot edge with kubeedge

exec_edge(){

    cd $PATH_OF_ELIOTFOLDER/scripts/src

    sshpass -p ${EDGENODEPASSWORD} \
    scp $PATH_OF_ELIOTFOLDER/scripts/src/config_kubeedge \
    ${EDGENODEUSR}@${EDGENODEIP}:$HOME_EDGENODE

    sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} \
    source config_kubeedge

    source config_kubeedge > /dev/null 2>&1
    sshpass -p ${EDGENODEPASSWORD} \
    ssh ${EDGENODEUSR}@${EDGENODEIP} ${common_steps}

    echo "After cloning the code in ELIOT edge node"
    sshpass -p ${EDGENODEPASSWORD} \
    scp /etc/kubeedge/certs.tgz ${EDGENODEUSR}@${EDGENODEIP}:$HOME_EDGENODE

    sshpass -p ${EDGENODEPASSWORD} \
    ssh ${EDGENODEUSR}@${EDGENODEIP} \
    sudo tar -xvzf $HOME/certs.tgz --directory /etc/kubeedge

    sshpass -p ${EDGENODEPASSWORD} \
    ssh ${EDGENODEUSR}@${EDGENODEIP} ${edge_start}
}

# start

source config_kubeedge > /dev/null 2>&1

take_keedge

execute_keedge_controller

exec_edge > /dev/null 2>&1

sleep 10
sudo kubectl get nodes

if [ "$(id -u)" = 0 ]; then
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" | \
tee -a "${HOME}/.profile"
    source "${HOME}/.profile"
else
    mkdir -p "${HOME}/.kube"
    sudo cp -i /etc/kubernetes/admin.conf "${HOME}/.kube/config"
    sudo chown "$(id -u)":"$(id -g)" "${HOME}/.kube/config"
fi

chmod +x $VERIFY_K8S
source $VERIFY_K8S

