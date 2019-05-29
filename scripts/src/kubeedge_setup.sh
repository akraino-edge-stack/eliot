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
common_steps="echo $GOPATH && \
echo $HOME && \
echo $(whoami) && \
sudo git clone https://github.com/kubeedge/kubeedge.git $GOPATH/src/github.com/kubeedge/kubeedge && \
source ~/.profile && \
cd $GOPATH/src && \
sudo chmod -R 777 github.com && \
cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm && \
make"

certif_copy="cd /etc/kubeedge &&\
scp certs.tar.gz"

edge_start="cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm && \
sudo chmod +x kubeedge && \
sudo ./kubeedge join --edgecontrollerip=$masternodeip --edgenodeid=edgenode001 --k8sserverip=$masternodeip:8080"

execute_keedge_controller(){
   cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm
   sudo chmod +x kubeedge
   ./kubeedge init
}

exec_edge(){
echo $(whoami)
echo =========
echo $(pwd)
echo ========
echo $GOPATH
echo ========
echo $HOME

user_check="jenkins"
home_path="/home/jenkins"
   #if [ $HOME == $home_path ];then
   cd /home/jenkins/work/workspace/eliot-deploy-kubeedge-virtual-daily-master/scripts/src
   #else
   #   cd $HOME/eliot/scripts/src
   #fi

   #if [ $HOME == $home_path ];then
   sshpass -p ${edgenodepassword} scp /home/jenkins/work/workspace/eliot-deploy-kubeedge-virtual-daily-master/scripts/src/config_kubeedge ${edgenodeusr}@${edgenodeip}:/root
   #else
   #   sshpass -p ${edgenodepassword} scp $HOME/eliot/scripts/src/config_kubeedge ${edgenodeusr}@${edgenodeip}:/root
   #fi

   sshpass -p ${edgenodepassword} ssh ${edgenodeusr}@${edgenodeip} \
   source config_kubeedge

   source config_kubeedge
   sshpass -p ${edgenodepassword} ssh ${edgenodeusr}@${edgenodeip} ${common_steps} < /dev/null

   echo "After cloning the code in ELIOT edge node"
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

sleep 10
sudo kubectl get nodes

#user_chec="jenkins"

#if [ $(whoami) == $user_chec ];then

chmod +x /home/jenkins/work/workspace/eliot-deploy-kubeedge-virtual-daily-master/scripts/verifyk8s.sh
source /home/jenkins/work/workspace/eliot-deploy-kubeedge-virtual-daily-master/scripts/verifyk8s.sh

#else

#  chmod +x $HOME/eliot/scripts/verifyk8s.sh
#  source $HOME/eliot/scripts/verifyk8s.sh

#fi
