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
SUPERUSER="root"
value=$(whoami)

# start

# kubeedge reset internally undo the things done by ./kubeedge init

if [ -d "$GOPATH/src/github.com/kubeedge/kubeedge/keadm" ]; then
   cd $GOPATH/src/github.com/kubeedge/kubeedge/keadm
   ./keadm reset
fi

# delete the previously existing certificates

if [ -d "/etc/kubeedge/ca" ]; then
   sudo rm -rf /etc/kubeedge/ca
fi

if [ -d "/etc/kubeedge/certs" ]; then
   cd /etc/kubeedge
   sudo rm -rf certs
fi

cd /etc/kubeedge
if [ -f "certs.tgz" ]; then
   sudo rm certs.tgz
fi

# delete the kubeedge code

if [ -d "$GOPATH/src" ]; then
   cd $GOPATH
   sudo rm -rf src
fi

# stop binaries edge_core edgecontroller

cd /usr/local/bin

if [ -f "edge_core" ]; then
   sudo rm edge_core
fi

if [ -f "edgecontroller" ]; then
   sudo rm edgecontroller
fi

if [ $value != $SUPERUSER ]; then
   sudo su
fi

cd

if [ -f $TESTYAML ]; then
   sudo rm $TESTYAML
fi

