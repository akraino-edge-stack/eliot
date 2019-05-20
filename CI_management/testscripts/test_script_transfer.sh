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

# This script will transfer the vm_connectivity.sh into ledgevm from edge node

transfer_file(){

  # scp script file from edge to ledgevm
  sshpass -p $LEDGEVM_PASSWORD \
  scp $HOME/test_vm_connectivity.sh \
  $LEDGEVM_USERNAME@$LEDGEVM_IP:$HOME

}


test_ledgevm(){

   sshpass -p $LEDGEVM_PASSWORD \
   ./test_vm_connectivity.sh

}

# start

source ../config_test.sh

transfer_file

test_ledgevm
