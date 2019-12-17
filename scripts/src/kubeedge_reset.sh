######################################################################
#                                                                    #
# The script is to reset the changes on ELIOT Manager and ELIOT nodes#
# done by kubeedge_setup.sh file.                                    #
# It releases the port used.                                         #
# It deletes the files created by the script on both Manager and node#
#machine                                                             #
# Script is tested in Ubuntu 16.04 version.                          #
######################################################################

# constants
OSPLATFORM=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

show_help()
{
  echo "This script will remove folders created on both master and node machines"
  echo "This script will release all the ports being used by the script."
  echo "This script will reset the kubelet service"
  echo "The changes will be first executed on manager machine and then node machines."
  echo "It will pick the node machine details from config_kubeedge file"
}

#Reset the changes on master machine
reset_master()
{
    cd /etc/kubeedge/kubeedge/edge && sudo mv edge_core edgecore
    cd /etc/kubeedge/kubeedge/cloud && sudo touch cloudcore
    sudo fuser -k -n tcp 6443
    sudo fuser -k -n tcp 10252
    sudo fuser -k -n tcp 10251
    sudo fuser -k -n tcp 2379
    sudo fuser -k -n tcp 10250
    sudo fuser -k -n tcp 10250
    sudo fuser -k -n tcp 10250
    sudo fuser -k -n tcp 2380
    sudo systemctl stop kubelet
    sudo rm -rf /src/github.com

    sudo rm -rf /var/lib/etcd
    sudo yes y | kubeadm reset
    sudo apt-get install iptables
    sudo iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
    sudo apt-get install ipvsadm
    cd /etc/kubernetes && sudo rm -rf bootstrap-kubelet.conf kubelet.conf pki
    echo "Successful reset on master"

reset_edge
}
#Resets the changes on node machines
reset_edge()
{
edge_core_folder="cd /etc/kubeedge/kubeedge/edge && sudo mv edge_core edgecore"
cloud_core_folder="cd /etc/kubeedge/kubeedge/cloud && sudo touch cloudcore"
release_port1="sudo fuser -k -n tcp 6443"
release_port2="sudo fuser -k -n tcp 10252"
release_port3="sudo fuser -k -n tcp 10251"
release_port4="sudo fuser -k -n tcp 2379"
release_port5="sudo fuser -k -n tcp 10250"
release_port6="sudo fuser -k -n tcp 2380"
stop_kubelet_service="sudo systemctl stop kubelet"
remove_kubeedge_folder="sudo rm -rf /src/github.com"
remove_folder1="sudo rm -rf /var/lib/etcd"
remove_folder2="cd /etc/kubernetes && sudo rm -rf bootstrap-kubelet.conf kubelet.conf pki"
kubeadm_reset="sudo yes y | kubeadm reset"
ip_tables_install="sudo apt-get install iptables ipvsadm"
ip_tables_reset="sudo iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X"

    

source $PATH_OF_ELIOTFOLDER/scripts/src/config_kubeedge > /dev/null 2>&1
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${edge_core_folder}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${cloud_core_folder}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${release_port1}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${release_port2}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${release_port3}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${release_port4}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${release_port5}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${release_port6}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${stop_kubelet_service}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${remove_kubeedge_folder}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${remove_folder1}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${remove_folder2}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${kubeadm_reset}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${ip_tables_install}
sshpass -p ${EDGENODEPASSWORD} ssh ${EDGENODEUSR}@${EDGENODEIP} ${ip_tables_reset}
echo "Successful Reset of Edge"
}

verify_reset_status()
{
echo "Success!!"
}

#Start

if [ $1 == "--help" ] || [ $1 == "-h" ];
then
  show_help
  exit 0
fi

if [[ $OSPLATFORM = *Ubuntu* ]]; then
   reset_master
   verify_reset_status
else
   echo "Script only supports Ubuntu Version."
fi
