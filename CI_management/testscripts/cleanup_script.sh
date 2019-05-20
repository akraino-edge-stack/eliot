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

# software packages cleanup

uninstall_softwares(){

   sudo apt-get purge --auto-remove qemu-system-arm

}

# internet configurations reset

internet_config_reset(){

   sudo ip link del tap0

}

# remove unwanted log files

remove_log_files(){

   if [ -f "$LOG_MAC" ]; then
       sudo rm $LOG_MAC
   else
       echo "$LOG_MAC does not exist"
   fi

   if [ -f "$LOG_NIC" ]; then
       sudo rm $LOG_NIC
   else
       echo "$LOG_NIC does not exist"
   fi

}


# start

source ../config_test.sh

uninstall_softwares

internet_config_reset
