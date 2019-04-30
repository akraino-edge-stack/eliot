#host_setup function is for configuring the host
host_setup(){
   #creating a tap interface in host
   sudo ip tuntap add tap0 mode tap
   #configuring tap interface with an address
   sudo ifconfig tap0 192.168.100.1
   #Replace fa:16:3e:1e:43:bd with your actual MAC address
   #nic=$(ifconfig  | grep 'HWaddr fa:16:3e:6b:09:7f' | cut -c1-4)
   #nicc is your active NIC card which is connected to internet
   #nicc=$(ip addr | awk '/state UP/ {print $2;exit}' | sed 's/.$//')
   ip addr | awk '/inet 30.0.0.20/' >>nic.txt
   nicc=$(awk 'NF>1{print $NF}' nic.txt)
   #setting un NAT rule with iptables for packet forwarding
   sudo iptables -t nat -A POSTROUTING -o $nicc -j MASQUERADE
   sudo iptables -I FORWARD 1 -i tap0 -j ACCEPT
   sudo iptables -I FORWARD 1 -o tap0 -m state --state RELATED,ESTABLISHED -j \
 ACCEPT
   cp /dev/null nic.txt
}

#vm_creation function is for creating ThinOs vm on host
vm_creation(){
   #Downloading ThinOS qcow2 file from public server
   wget http://139.159.210.254/LerOS/x86_64/Images/disk.qcow2
   #echo 'setting macrandom variable...'
   hexchars="0123456789ABCDEF"
   #setting up a random macaddress for the ThinOS VM
   end=$( for i in {1..6} ; do echo -n \
   ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
   macrandom=00:60:2F$end
   echo $macrandom
   echo 'Creating ThinOS VM'
   #qemu cmd to create the ThinOS VM with the macgenerated in previous step
   #with tap interfaces which is created in host
   qemu-system-x86_64 -hda disk.qcow2 -nographic -no-reboot -m 1024 -smp 1 \
   -net nic,model=virtio,macaddr=$macrandom -net tap,ifname=tap0
   echo 'inside vm created.....'
}

display_help(){
  echo
  echo 'host_setup function process'
  echo
  echo '1.create tap interface named tap0 or any tap interface'
  echo
  echo '2.assign the created tap interface with ip address'
  echo
  echo '3.finding out the active Network interface'
  echo
  echo '4.set NAT rule to modify iptables to packet forward from tap to router'
  echo
  echo
  echo 'vm_creation function process'
  echo
  echo '1.Download ThinOS qcow2 from the 139.159.210.254'
  echo
  echo '2.create a random mac address and store it in a variable'
  echo
  echo '3.Use qemu command for x86_64 to create the ThinOS VM by mentioning the
  model as virtio, assign the macaddress generated randomly to macaddr, and 
assign -net as tap, ifname as exact tap interface which is created in host'
  echo
}

if [ $1 = "--help" ]
then
  display_help
  exit 0
fi

#invoke function to configure host
host_setup
#invoke function to create thinOS VM
vm_creation
