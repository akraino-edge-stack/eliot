#!/bin/bash -ex
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

promyml=~/prometheus.yml
workernodeip=""
blank=""
count=1
firstline=1
while read line
do
  if [ $count -gt $firstline ]; then
     workernodeip+="','"
  fi
  nodeinfo="${line}"
  nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
  echo $nodeip
  workernodeip+=$nodeip
  workernodeip+=":8081"
  echo $workernodeip
  count=2
  echo $count
done < nodelist > /dev/null 2>&1

echo "workernodeip="
echo $workernodeip

cat <<EOF > "${promyml}"
---
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']

  - job_name: cadvisor
    scrape_interval: 5s
    static_configs:
      - targets: ['$workernodeip']
EOF
