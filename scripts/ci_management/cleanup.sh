#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# start

kubeedge reset

reset="kubeedge reset --k8sserverip ${masternodeip}:8080"

while read line
do
    nodeinfo="${line}"
    nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
    nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
    nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
    masternodeip=$(echo ${nodeinfo} | cut -d"|" -f3)

    sshpass -p ${nodepaswd} \
    kubeedge reset --k8sserverip ${masternodeip}:8080

done < nodelist

