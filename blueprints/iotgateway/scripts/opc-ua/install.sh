#!/bin/bash

##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit

# set the docker name and docker tag when you build
# export DOCKER_NAME=eliot/opc-ua
# export DOCKER_TAG=latest

export ELIOT_DIR=$(cd $(dirname $0); pwd)
export WORK_DIR=$ELIOT_DIR/work
export CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz
export SCONS_PPA_URL=http://repo.okay.com.mx/centos/7/x86_64/release//scons-2.3.0-1.el7.centos.noarch.rpm
export GET_PIP_URL=https://bootstrap.pypa.io/get-pip.py
export OPCUA_REPO=https://github.com/edgexfoundry-holding/protocol-opcua-c.git
export DOCKER_NAME=${DOCKER_NAME:-"eliot/opc-ua"}
export DOCKER_TAG=${DOCKER_TAG:-"latest"}

# Clean and Create the work directory
rm -rf $WORK_DIR
mkdir -p $WORK_DIR

yum install -y gcc git wget
yum groupinstall -y 'Development Tools'
# Get the package and source code
cd $WORK_DIR
wget $CMAKE_URL
wget $SCONS_PPA_URL
wget $GET_PIP_URL
git clone $OPCUA_REPO

# Install Package
rpm -Uvh scons-2.3.0-1.el7.centos.noarch.rpm
python get-pip.py

# Build and Install camke
tar xzf cmake-3.15.2.tar.gz
cd ${WORK_DIR}/cmake-3.15.2
./bootstrap
make
make install

# Build the opc-ua server and client
cd ${WORK_DIR}/protocol-opcua-c/
./build.sh

set +x
echo "####################################################"
echo "# If you want to  start the server, follow below steps"
echo "# cd ${WORK_DIR}/protocol-opcua-c/example/out"
echo "# ./server"
echo "####################################################"

