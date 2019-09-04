#!/bin/bash -ex

##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

#source eliotconfig
CNI_TYPE=${K8s_CNI_TYPE}


apply_calico()
{
# Installing Calico Plugin 

  kubectl apply -f cni/calico/rbac.yaml
  kubectl apply -f cni/calico/calico.yaml

}




apply_flannel()
{
# Installing  Flannel Plugin
# This line will have replace value of POD_CIDR_NETWORK
  kubectl apply -f cni/flannel/kube-flannel.yml

}


case ${CNI_TYPE} in
 'calico')
        echo "Install calico ..."
        apply_calico
        ;;
 'flannel')
        echo "Install flannel ..."
        apply_flannel
        ;;
 *)
        echo "${CNI_TYPE} is not supported"
        exit 1
        ;;
esac



