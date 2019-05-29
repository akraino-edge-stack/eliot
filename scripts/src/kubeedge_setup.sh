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

source config_kubeedge
common_steps="sudo git clone https://github.com/kubeedge/kubeedge.git $GOPATH/src/github.com/kubeedge/kubeedge && \
source ~/.profile && \
cd $GOPATH/src && \
sudo chmod -R 777 github.com && \
cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm && \
make"

certif_copy="cd /etc/kubeedge &&\
scp certs.tar.gz"

edge_start="cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm && \
sudo chmod +x kubeedge && \
sudo ./kubeedge join --edgecontrollerip=$masternodeip --edgenodeid=eliotedge02 --k8sserverip=$masternodeip:8080"

execute_keedge_controller(){
   cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm
   sudo chmod +x kubeedge
   ./kubeedge init
}


exec_edge(){

   cd $HOME/eliot/scripts/src
   sshpass -p ${edgenodepassword} scp $HOME/release/eliot/scripts/src/config_kubeedge ${edgenodeusr}@${edgenodeip}:/root

   sshpass -p ${edgenodepassword} ssh ${edgenodeusr}@${edgenodeip} \
   source config_kubeedge
   
   source config_kubeedge
   sshpass -p ${edgenodepassword} ssh ${edgenodeusr}@${edgenodeip} ${common_steps} < /dev/null
echo "after common_steps"
   sshpass -p ${edgenodepassword} scp /etc/kubeedge/certs.tgz ${edgenodeusr}@${edgenodeip}:/etc/kubeedge

   sshpass -p ${edgenodepassword} \
   ssh ${edgenodeusr}@${edgenodeip} \
   tar -xvzf /etc/kubeedge/certs.tgz --directory /etc/kubeedge
   
   sshpass -p ${edgenodepassword} ssh ${edgenodeusr}@${edgenodeip} ${edge_start} < /dev/null
}

# start

source config_kubeedge

take_keedge

execute_keedge_controller

exec_edge
sudo kubectl get nodes

chmod +x $HOME/eliot/scripts/verifyk8s.sh
source $HOME/eliot/scripts/verifyk8s.sh
