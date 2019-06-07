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
   source ~/.profile
   cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm
   make
}

source config_kubeedge > /dev/null 2>&1

common_steps="echo $GOPATH && \
echo $HOME && \
echo $(whoami) && \
sudo git clone https://github.com/kubeedge/kubeedge.git $GOPATH/src/github.com/kubeedge/kubeedge && \
source ~/.profile && \
cd $GOPATH/src && \
sudo chmod -R 777 github.com && \
cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm && \
make"

edge_start="cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm && \
sudo chmod +x kubeedge && \
sudo ./kubeedge join --edgecontrollerip=$MASTERNODEIP --edgenodeid=$EDGENODEID --k8sserverip=$MASTERNODEIP:8080"

execute_keedge_controller(){
   cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm
   sudo chmod +x kubeedge
   ./kubeedge init
}

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
   sshpass -p ${EDGENODEPASSWORD} 
   scp /etc/kubeedge/certs.tgz ${EDGENODEUSR}@${EDGENODEIP}:/etc/kubeedge

   sshpass -p ${EDGENODEPASSWORD} \
   ssh ${EDGENODEUSR}@${EDGENODEIP} \
   tar -xvzf /etc/kubeedge/certs.tgz --directory /etc/kubeedge

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

chmod +x $PATH_OF_ELIOTFOLDER/scripts/verifyk8s.sh
source $PATH_OF_ELIOTFOLDER/scripts/verifyk8s.sh

