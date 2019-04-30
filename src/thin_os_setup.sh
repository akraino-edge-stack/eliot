# !/bin/bash
#
# This script will execute automatically on executing eliot_setup.sh
# This script is to setup the ELIOT edge node from ELIOT manager
# Script can install ThinOS VM on x86 and arm on ELIOT edge node
# It will setup the Edge Lightweight OS on ELIOT node on top of ELIOT Topology
# From ELIOT manager, ELIOT node is invoked and Edge node's vm is setup
# Using ELIOT node topology, setup from ELIOT master
# In this script, ELIOT edge node is configured
# 
###############################################################################

# constants for ELIOT manager and ELIOT node configuration

TAP='tap0'
TAP_INTERFACE='192.168.100.1'
EDGE_NODE_IP_PATTERN='inet 30.0.0.19'
EDGE_OS_PATH_X86='http://139.159.210.254/LerOS/x86_64/Images/disk.qcow2'
EDGE_OS_PATH_ARM='http://139.159.210.254/LerOS/aarch64/Images/cloud/disk.qcow2'
EDGE_OS_QEMU_EFI='http://139.159.210.254/LerOS/aarch64/Images/cloud/QEMU_EFI.fd'


# Installation of required pre-requisite software packages in ELIOT edge node

install_software_packages_x86(){

  sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
  sudo apt install qemu-system-x86

}

install_software_packages_arm(){

  sudo apt-get install qemu-kvm qemu-system-arm qemu-efi

}


#edge_node_setup function is for configuring the ELIOT Edge node

edge_node_setup(){

   #creating and configuring tap interface in ELIOT node
   sudo ip tuntap add $TAP mode tap
   sudo ifconfig $TAP $TAP_INTERFACE

   #touch nic.txt

   #nicc is your active NIC card which is connected to internet
   ip addr | awk -v pat="$EDGE_NODE_IP_PATTERN" '$0 ~ pat' >>nic.txt
   NICC=$(awk 'NF>1{print $NF}' nic.txt)

   #setting up NAT rule with iptables for ELIOT edge node packet forwarding
   sudo iptables -t nat -A POSTROUTING -o $NICC -j MASQUERADE
   sudo iptables -I FORWARD 1 -i $TAP -j ACCEPT
   sudo iptables -I FORWARD 1 -o $TAP -m state --state RELATED,ESTABLISHED -j \
 ACCEPT

   cp /dev/null nic.txt

}


# edge_node_vm_creation is for creating Edge ThinOs vm on Edge node in ELIOT

edge_node_x86_vm_setup(){

   install_software_packages_x86

   #Downloading ThinOS qcow2 file from public server
   wget $EDGE_OS_PATH_X86

   #setting up a random macaddress for the ThinOS VM of ELIOT
   HEXCHARS="0123456789ABCDEF"
   END=$( for i in {1..6} ; do echo -n \
   ${HEXCHARS:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )

   MACRANDOM=00:60:2F$END

   #qemu cmd to setup the Edge_node with the macgenerated in previous step
   qemu-system-x86_64 -hda disk.qcow2 -nographic -no-reboot -m 1024 -smp 1 \
   -net nic,model=virtio,macaddr=$MACRANDOM -net tap,ifname=$TAP

}


edge_node_arm_vm_setup(){

   install_software_packages_arm

   wget $EDGE_OS_PATH_ARM
   wget $EDGE_OS_QEMU_EFI
   #set a random mac value for ThinOS VM of ELIOT node

   HEXCHARS="0123456789ABCDEF"
   END=$( for i in {1..6} ; do echo -n \
   ${HEXCHARS:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g')

   MACRANDOM=00:60:2F$END

   #qemu cmd to setup the Edge_node with the generated mac and tap

   qemu-system-aarch64 -enable-kvm -cpu host -M virt,gic_version=3 \
   -nographic -smp 1 -m 1024 -bios QEMU_EFI.fd \
   -drive if=none,file=disk.qcow2,id=hd0 \
   -device virtio-blk-device,drive=hd0 -nographic \
   -net nic,model=virtio,macaddr=$MACRANDOM \
   -net tap,ifname=$TAP,script=no,downscript=no -vnc :6

}

display_help(){

  echo
  echo 'edge_node_setup for ELIOT edge node configurations'
  echo 'It will create tap interface and assign it with ip address'
  echo 'Then setting up NAT rule to modify iptables in ELIOT edge node'

  echo 'edge_node_x86_vm_setup and edge_node_arm_vm_setup for ELIOT
ThinOS VM setup'

  echo 'It will install ThinOS VM in ELIOT edge node from 139.159.210.254'
  echo 'Using qemu command to create the ThinOS VM in ELIOT edge node'

}


if [ $1 = "--help" ];
then
  display_help
  exit 0
fi


#start

edge_node_setup

LINUX_KERNEL=$(uname -m)

if [ $LINUX_KERNEL = "x86_64" ];
then
  edge_node_x86_vm_setup
elif [ $LINUX_KERNEL = "aarch64" ]
then
  edge_node_arm_vm_setup
else
  echo 'Platform not supported. Please check your platform'
  echo 'Currently supported platforms are x86_64,arm64'
  exit 0
fi

