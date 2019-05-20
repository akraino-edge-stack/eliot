# !/bin/bash
#
# Copyright (c) 2019 HUAWEI TECHNOLOGIES and others. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
###############################################################################

# connect to edge node

invoke_eliot_edge(){

  # scp robot file from ELIOT Master to ELIOT Edge and execute it

  sshpass -p $EDGENODE_PASSWORD \
  scp $HOME/eliot/CI_management/testscripts/test.robot \
  $EDGENODE_USERNAME@$EDGENODE_IP:$HOME

  sshpass -p $EDGENODE_PASSWORD \
  scp $HOME/eliot/CI_management/testscripts/test_script_transfer.sh \
  $EDGENODE_USERNAME@$EDGENODE_IP:$HOME

  sshpass -p $EDGENODE_PASSWORD ssh $EDGENODE_USERNAME@$EDGENODE_IP \
  'robot test.robot'

  sshpass -p $EDGENODE_PASSWORD ssh $EDGENODE_USERNAME@$EDGENODE_IP \
  'source test_script_transfer.sh'

  # take robot logs from ELIOT Edge node to ELIOT Master

  sshpass -p $EDGENODE_PASSWORD ssh $EDGENODE_USERNAME@$EDGENODE_IP \
  'scp log.html root@172.30.14.75:$HOME/logs'

  # scp script file from master to edge

  sshpass -p $EDGENODE_PASSWORD \
  scp $HOME/eliot/CI_management/testscripts/test_vm_connectivity.sh \
  $EDGENODE_USERNAME@$EDGENODE_IP:$HOME

}

# start

source ../config_test.sh

invoke_eliot_edge
