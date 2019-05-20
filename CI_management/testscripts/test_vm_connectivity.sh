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

functionality_check(){

   ping -c 1 -i 0.2 $EDGE_IP >> testlog.txt
   ping -c 1 -i 0.2 www.google.com >> testlog.txt
   ping -c 1 -i 0.2 8.8.8.8 >> testlog.txt

}


# start

source ../config_test.sh

functionality_check

scp testlog.txt root@$ELIOT_MASTER_IP:/home/ubuntu/eliot/src/logs
