#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################


#stop cadvisor statement executed at ELIOT Edge Node
if [ $(sudo docker ps | grep cadvisor | wc -l) -gt 0 ];then
 sudo docker stop $(sudo docker ps | grep cadvisor | awk '{ print $1 }')
fi

if [ $(sudo docker ps -a | grep cadvisor | wc -l) -gt 0 ];then
  sudo docker rm $(sudo docker ps -a | grep cadvisor | awk '{ print $1 }')
fi
