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


# This script will execute automatically on executing ledge_setup.sh
# This script is to setup the LEDGE RP VM on x86 and arm64
# From ELIOT Manager, ELIOT node is invoked and Edge node's VM is setup

# installation of required pre-requisite software packages in ELIOT Edge node

install_software_packages_x86(){

  sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
  sudo apt install qemu-system-x86

}

install_software_packages_arm(){

  sudo apt-get install qemu-kvm qemu-system-arm qemu-efi

}

# configuring ELIOT Edge node for LEDGERP VM environment

edge_node_setup(){

   #creating and configuring tap interface in ELIOT node
   sudo ip tuntap add $TAP mode tap
   sudo ifconfig $TAP $TAP_INTERFACE_LEDGE

   sudo ip tuntap add $TAP $TAP_INTERFACE_LEDGE

   #nicc is your active NIC card which is connected to internet
   ip addr | awk -v pat="$EDGE_NODE_IP_PATTERN" '$0 ~ pat' >>nic_ledge.txt
   NIC_LEDGE=$(awk 'NF>1{print $NF}' nic_ledge.txt)

   #setting up NAT rule with iptables for ELIOT edge node packet forwarding
   sudo iptables -t nat -A POSTROUTING -o $NIC_LEDGE -j MASQUERADE
   sudo iptables -I FORWARD 1 -i $TAP -j ACCEPT
   sudo iptables -I FORWARD 1 -o $TAP -m state --state RELATED,ESTABLISHED -j \
 ACCEPT

   cp /dev/null nic_ledge.txt

}


# edge_node_vm_creation is for creating Edge LedgeRP VM on Edge node in ELIOT

edge_node_x86_ledgevm_setup(){

   install_software_packages_x86

   #setting up a random macaddress for the ThinOS VM of ELIOT
   HEXCHARS="0123456789ABCDEF"
   END=$( for i in {1..6} ; do echo -n \
   ${HEXCHARS:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )

   MACRANDOM_LEDGE=00:60:2F$END
   echo $MACRANDOM_LEDGE >>mac_ledge.txt

   #qemu-cmd t setup Ledge RP VM in ELIOT Edge node

   qemu-system-x86_64 -device virtio-net-pci,netdev=net0,mac=$MACRANDOM_LEDGE \
-netdev tap,id=net0,ifname=$TAP,script=no,downscript=no \
-drive if=virtio,file=$LEDGE_PATH_X86_FILEIMAGE \
-nographic -nographic -m 4096 -cpu core2duo -m 4096 -serial mon:stdio -serial null \
-kernel bzImage--mainline-5.1-r0-ledge-qemux86-64.bin \
-append "root=/dev/vda rw highres=off  console=ttyS0 mem=4096M \
ip=192.168.100.2::192.168.100.1:255.255.255.0 console=ttyS0 console=tty"

   cp /dev/null mac_ledge.txt
}

edge_node_arm_ledgevm_setup(){

   install_software_packages_arm

   HEXCHARS="0123456789ABCDEF"
   END=$( for i in {1..6} ; do echo -n \
   ${HEXCHARS:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g')

   MACRANDOM=00:60:2F$END
   echo $MACRANDOM >>mac_ledge.txt

   #qemu-cmd to setup Ledge RP VM in ELIOT Edge node

   qemu-system-aarch64 -device virtio-net-device,netdev=net0,mac=$MACRANDOM \
-netdev tap,id=net0,ifname=$TAP,script=no,downscript=no \
-drive id=disk0,file=$LEDGE_PATH_ARM_FILEIMAGE,if=none,format=raw \
-device virtio-blk-device,drive=disk0 -show-cursor -device virtio-rng-pci -monitor null  -nographic -m 4096 \
-machine virt -cpu cortex-a57 -m 4096 -serial mon:stdio -serial null -kernel Image--mainline-5.1-r0-ledge-qemuarm64.bin \
-append "root=/dev/vda rw highres=off  console=ttyS0 mem=4096M \
ip=192.168.100.2::192.168.100.1:255.255.255.0 console=ttyAMA0,38400"

   cp /dev/null/mac_ledge.txt
}

display_help(){

  echo
  echo 'edge_node_setup for ELIOT edge node configurations'
  echo 'It will create tap interface and assign it with ip address'
  echo 'Then setting up NAT rule to modify iptables in ELIOT edge node'
  echo 'edge_node_x86_ledgevm_setup and edge_node_arm_ledgevm_setup for ELIOT
ThinOS VM setup'
  echo 'Using qemu command to create the LEDGE RP VM in ELIOT edge node'

}


if [ $1 = "--help" ];
then
  display_help
  exit 0
fi


# start

source ../config_installation.sh

edge_node_setup

LINUX_KERNEL=$(uname -m)

if [ $LINUX_KERNEL = "x86_64" ];
then
  edge_node_x86_ledgevm_setup
elif [ $LINUX_KERNEL = "aarch64" ]
then
  edge_node_arm_ledgevm_setup
else
  echo 'Platform not supported. Please check your platform'
  echo 'Currently supported platforms are x86_64,arm64'
  exit 0
fi

