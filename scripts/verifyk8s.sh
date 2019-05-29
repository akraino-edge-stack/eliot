#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

NGINXDEP=~/testk8s-nginx.yaml

cat <<EOF > "${NGINXDEP}"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.15.12
          ports:
            - containerPort: 80
              hostPort: 80
EOF

#check if nginx is already deployed
if ! kubectl get pods | grep nginx; then
  kubectl create -f testk8s-nginx.yaml
fi

#To check whether the deployment is succesesfull
retry=10
while [ $retry -gt 0 ]
do
  if [ 2 == "$(kubectl get pods | grep -c -e STATUS -e Running)" ]; then
    break
  fi
  ((retry-=1)) 
  sleep 10
done
[ $retry -gt 0 ] || exit 1
