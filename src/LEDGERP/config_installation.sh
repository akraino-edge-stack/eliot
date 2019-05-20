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

# This file will setup the configurations for ELIOT Setup

HOME=''

EDGENODE_PASSWORD=''
EDGENODE_USERNAME=''
EDGENODE_IP=''

TAP_INTERFACE='tap0'
TAP_INTERFACE_LEDGE='192.168.100.1'

LEDGE_PATH_X86_FILEIMAGE='ledge-iot-ledge-qemux86-64.rootfs.ext4'
LEDGE_PATH_x86_BIN='bzImage--mainline-5.1-r0-ledge-qemux86-64.bin'
LEDGE_PATH_ARM_FILEIMAGE='ledge-iot-ledge-qemuarm64.rootfs.ext4'
LEDGE_PATH_ARM_BIN='Image--mainline-5.1-r0-ledge-qemuarm64.bin'
