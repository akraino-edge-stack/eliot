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
PROMETHEUS_HOST_PORT="9090"
PROMETHEUS_CONTAINTER_PORT="9090"
#cp ci_management/prometheus.yml $HOME
source generatePromeyml.sh
if [ ! -d "/etc/prometheus" ]; then
  sudo mkdir /etc/prometheus
fi

sudo docker run -p ${PROMETHEUS_HOST_PORT}:${PROMETHEUS_CONTAINTER_PORT} \
     -v ~/prometheus.yml:/etc/prometheus/prometheus.yml \
     -d prom/prometheus \
     --config.file=/etc/prometheus/prometheus.yml 
