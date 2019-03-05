#!/bin/bash -ex

##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# This script is to install common software for ELIOT.
# To be executed in Eliot Manager and Eliot Nodes.
# Script will install Docker software.
# Script has to be executed in Ubuntu 16.04.

# Set Docker version
DOCKER_VERSION=18.06.1~ce~3-0~ubuntu

sudo apt-get update && sudo apt-get install -y git

# Install Docker as Prerequisite
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
  "deb https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

sudo apt update
sudo apt install -y docker-ce=${DOCKER_VERSION}

