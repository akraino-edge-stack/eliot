#!/bin/bash -ex
# This script is to install common software and commands to be executed in Eliot Manager and Eliot Nodes.
# Script will install Docker and Kubernetes software.
# Script has to be executed in CentOS7.5 version.

DOCKER_VERSION=18.06.1~ce~3-0~ubuntu
ELIOT_REPO="https://gerrit.akraino.org/r/eliot"


#sudo apt-get update && sudo apt-get install -y git &&\
 #sudo rm -rf ~/.kube 

sudo apt-get update && sudo apt-get install -y git &&\
  sudo rm -rf ~/.kube ~/eliot &&\
  git clone ${ELIOT_REPO}

# Install Docker as Prerequisite
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
  "deb https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

sudo apt update
sudo apt install -y docker-ce=${DOCKER_VERSION} 

# Disable swap on your machine
sudo swapoff -a

