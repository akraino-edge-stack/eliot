#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# constants

TESTYAML="testk8s-nginx.yaml"

# start

source ../src/config_kubeedge
cd
kubectl delete -f testk8s-nginx.yaml

sshpass -p ${EDGENODEPASSWORD} \
scp ${PATH_OF_ELIOTFOLDER}/scripts/ci_management/cleanup_edge.sh \
${EDGENODEUSR}@${EDGENODEIP}:$HOME_EDGENODE

sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} \
source cleanup_edge.sh

cd $PATH_OF_ELIOTFOLDER/scripts/ci_management
source cleanup_master.sh
