########################################################################################
#                                                                                      #
# The script is to reset the settings on ELIOT Manager and ELIOT nodes                 #
# before running the setup.sh file again on the same setup.                            #
# It resets the settings of kubeadm and restarts its service                           #
# It releases the ports used.                                                          #
# It deletes the files created for kubernetes on node machine                          #
# Script is tested in Ubuntu 16.04 version.                                            #
########################################################################################

# constants
OSPLATFORM=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

show_help()
{
  echo "The script is to reset the settings on ELIOT Manager and ELIOT nodes which "
  echo "needs to be done before executing the setup.sh file again."
  echo "The changes will be first executed on manager machine and then on the node machines."
  echo "It will pick the node machine details from nodelist file"
}

# Resetting ELIOT Manager Node
reset_k8smaster()
{
 sudo yes y | kubeadm reset
 sudo apt-get install iptables
 sudo iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
 sudo apt-get install ipvsadm
 sudo systemctl restart kubelet
 sudo fuser -k -n tcp 10250

reset_k8sworkers
}

#Resetting ELIOT Worker Node
reset_k8sworkers()
{
RESET_KUBEADM="sudo yes y | kubeadm reset"
INSTALL_IPVSADM="sudo apt-get install ipvsadm"
RESTART_KUBELET="sudo systemctl restart kubelet"
RESET_PORT="sudo fuser -k -n tcp 10250"
#REMOVE_KUBE_FILES="cd /etc/kubernetes && sudo rm -rf !('manifests') "
REMOVE_KUBE_FILES="cd /etc/kubernetes && sudo rm -rf bootstrap-kubelet.conf kubelet.conf pki"
REMOVE_CADVISOR_FILES="docker rm cadvisor-iot-node1"

#Read all the Worker Node details from nodelist file.
 while read line
 do
     nodeinfo="${line}"
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${RESET_KUBEADM} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${INSTALL_IPVSADM} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${RESTART_KUBELET} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${RESET_PORT} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_KUBE_FILES} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_CADVISOR_FILES} < /dev/null
 done < nodelist > /dev/null 2>&1
}

verify_reset_status()
{
echo "Success!!"
}

if [ $1 == "--help" ] || [ $1 == "-h" ];
then
  show_help
  exit 0
fi

if [[ $OSPLATFORM = *Ubuntu* ]]; then
   reset_k8smaster
   verify_reset_status
else
   echo "The script supports only Linux - Ubuntu"
fi
