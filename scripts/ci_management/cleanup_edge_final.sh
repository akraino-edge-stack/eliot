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

NGINX=$(sudo docker ps | grep nginx | wc -l)
KUBEPROXY=$(sudo docker ps | grep k8s.gcr.io | wc -l)
CONSTZERO="0"

# start

echo "nginx container stop"
if [ $NGINX != $CONSTZERO ]; then
   sudo docker kill $(docker ps -q --filter ancestor=nginx:1.15.12 )
fi

echo "kubeproxy container stop"
if [ $KUBEPROXY != $CONSTZERO ]; then
   sudo docker kill $(docker ps -q --filter ancestor=k8s.gcr.io/kube-proxy:v1.14.2 )
fi
echo "Finished"
