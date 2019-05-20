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
##############################################################################

# transfer clean script to ELIOT EDGE node from ELIOT Master

invoke_eliot_edge(){

  sshpass -p $EDGENODE_PASSWORD \
  scp $HOME/eliot/CI_management/testscripts/cleanup_script.sh \
  $EDGENODE_USERNAME@$EDGENODE_IP:$HOME

  sshpass -p $EDGENODE_PASSWORD ssh $EDGENODE_USERNAME@$EDGENODE_IP \
  'source cleanup_script.sh'

}

# start

source ../config_test.sh

invoke_eliot_edge
