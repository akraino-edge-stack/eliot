#!/bin/bash -ex

##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# To verify edgex platform deployment on k8s.

retrytimes=10
while [ $retrytimes -gt 0 ]
do
 if [ 1 == "$(kubectl get pods | grep edgex-config-seed | grep -i completed | wc -l)" ]; then
    break
 fi
 ((retrytimes-=1))
 sleep 5
done
[ $retrytimes -gt 0 ] || exit 1

# Reset the variable to check Running status of other edgex platform microservices

retrytimes=20
while [ $retrytimes -gt 0 ]
do
 if [ 12 == "$(kubectl get pods | grep edgex | grep Running | wc -l)" ]; then
    echo "Edgex Platform is successfully deployed on ELIOT !!!!"
    break
 fi
 ((retrytimes-=1))
 sleep 5
done
[ $retrytimes -gt 0 ] || exit 1

