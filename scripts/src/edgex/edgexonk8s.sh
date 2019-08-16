#!/bin/bash -ex
#############################################################################
# Copyright (c) 2019 Huawei Tech and others.                                #
# All rights reserved. This program and the accompanying materials          #
# are made available under the terms of the Apache License, Version 2.0     #
# which accompanies this distribution, and is available at                  # 
# http://www.apache.org/licenses/LICENSE-2.0                                #
#############################################################################

#######################################################################################
# The script is to setup the Edgex Foundry application as POD in Kubernetes.          #
#######################################################################################



git clone https://github.com/edgexfoundry-holding/edgex-kubernetes-support.git
cd edgex-kubernetes-support/releases/edinburgh/kubernetes
ls
kubectl create -k .
kubectl get ingress
kubectl get pod
kubectl get svc







