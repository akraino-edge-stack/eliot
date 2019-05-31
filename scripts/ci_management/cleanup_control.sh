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

source ../src/config_kubeedge

cd $PATH_OF_ELIOTCODE/scripts/ci_management
source cleanup_master.sh

sshpass -p ${EDGENODEPASSWORD} \
scp ${PATH_OF_ELIOTCODE}/scripts/ci_management/cleanp_edge.sh ${EDGENODEUSR}@${EDGENODEIP}:$HOME_EDGENODE

sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} \
source cleanup_edge.sh
