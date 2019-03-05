#!/bin/bash -ex
# This script is to install common software for ELIOT.
# To be executed in Eliot Manager and Eliot Nodes.
# Script will install Docker software.
# Script has to be executed in Ubuntu 16.04.

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

