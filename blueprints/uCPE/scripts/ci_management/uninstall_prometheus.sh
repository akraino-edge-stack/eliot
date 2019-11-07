#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################


# stop prometheus in ELIOT Manager

if [ $(sudo docker ps | grep prometheus | wc -l) -gt 0 ];then
    echo "Stopping prometheus container id :- $(sudo docker ps | grep prometheus | awk '{ print $1 }')"
    sudo docker stop $(sudo docker ps | grep prometheus | awk '{ print $1 }')
fi
if [ $(sudo docker ps -a | grep prometheus | wc -l) -gt 0 ];then
    echo "Removing prometheus container id $(sudo docker ps -a | grep prometheus | awk '{ print $1 }')"
    sudo docker rm $(sudo docker ps -a | grep prometheus | awk '{ print $1 }')
fi

