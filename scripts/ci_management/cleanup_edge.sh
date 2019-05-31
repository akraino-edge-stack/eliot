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

source config_kubeedge

cd

if [ -f "test-k8s-nginx.yaml" ]; then
   kubectl delete -f test-k8s-nginx.yaml
   sudo rm test-k8s-nginx.yaml
fi

if [ -d "/root/go/src/github.com/kubeedge/kubeedge/keadm" ]; then
   cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm
   ./kubeedge reset --k8sserverip ${masternodeip}:8080
fi

cd /etc/kubeedge

if [ -f "certs.tgz" ]; then
   sudo rm -rf certs.tgz
fi

if [ -d "/etc/kubeedge/ca" ]; then
   sudo rm -rf /etc/kubeedge/ca
fi

if [-d "/etc/kubeedge/certs" ]; then
   sudo rm -rf /etc/kubeedge/certs
fi

if [ -d "/root/go/src"]; then
   sudo rm -rf /root/go/src
fi

# stop binaries edge_core
cd /usr/local/bin

if [ -f "edge_core"]
   sudo rm edge_core
fi

