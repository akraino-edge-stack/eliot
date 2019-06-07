#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# The script is to stop and remove the prometheus and cadvisor containers from 
# ELIOT Manager and ELIOT Edge Node respectively.

# stop prometheus in ELIOT Manager
source uninstall_prometheus.sh | tee uninstall_prometheus.log

#stop cadvisor statement executed at ELIOT Edge Node
stop_cadvisor_atedge="cd eliot/scripts/ci_management && source uninstall_cadvisor.sh"
# Read all the Worker Node details from nodelist file.
while read line
do
     nodeinfo="${line}"
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${stop_cadvisor_atedge}
done < ../nodelist > /dev/null 2>&1

