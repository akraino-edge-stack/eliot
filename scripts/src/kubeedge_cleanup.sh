
######################################################################
#                                                                    #
# The script is to undo the changes on ELIOT Manager and ELIOT nodes #
# done by setup.sh file.                                             #
# It uninstalls docker, kubernetes.                                  #
# It releases the port used.                                         #
# It deletes the files created for kubernetes in node machine        #
# Script is tested in Ubuntu 16.04 version.                          #
######################################################################

# constants
OSPLATFORM=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

show_help()
{
  echo "This script will remove docker and its related files from the master and node machines"
  echo "This script will remove kubeadm kubectl kubelet kubernetes from the master and node machines"
  echo "The changes will be first executed on manager machine and then node machines."
  echo "It will pick the node machine details from nodelist file"
  echo "This file supports Linux- Ubuntu version only"
}

# Rollbacking the changes on ELIOT Manager Node
rollback_k8smaster()
{
sudo yes y | apt-get upgrade
sudo apt-get install iptables
sudo iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
sudo apt-get install ipvsadm
sudo fuser -k -n tcp 10250
sudo yes y | apt-get purge -y docker-engine
sudo yes y | apt-get purge -y docker
sudo yes y | apt-get purge -y docker.io
sudo yes y | apt-get purge -y docker-ce
sudo yes y | apt-get purge -y docker-ce-cli
sudo yes y | groupdel docker
sudo yes y | kubeadm reset
sudo yes y | apt-get purge kubeadm
sudo yes y | apt-get purge kubectl
sudo yes y | apt-get purge kubelet
sudo yes y | apt-get purge kube*
sudo yes y | apt-get purge kubernetes-cni
sudo rm -rf ~/.kube
sudo yes y | apt-get autoremove
sudo yes y | apt-get autoclean

rollback_k8sworkers

}

#Rollbacking the changes on ELIOT Worker Node
rollback_k8sworkers()
{
UPGRADE1="sudo yes y | apt-get upgrade"
INSTALL_IPVSADM="sudo apt-get install ipvsadm"
RESET_PORT="fuser -k -n tcp 10250"
#REMOVE_KUBE_FILES="cd /etc/kubernetes && sudo rm -rf !('manifests') "
REMOVE_KUBE_FILES="cd /etc/kubernetes && sudo rm -rf bootstrap-kubelet.conf kubelet.conf pki"
REMOVE_DOCKER1="sudo yes y | apt-get purge -y docker-engine"
REMOVE_DOCKER2="sudo yes y | apt-get purge -y docker"
REMOVE_DOCKER3="sudo yes y | apt-get purge -y docker.io"
REMOVE_DOCKER4="sudo yes y | apt-get purge -y docker-ce"
REMOVE_DOCKER5="sudo yes y | apt-get purge -y docker-ce-cli"
REMOVE_DOCKER6="sudo yes y | groupdel docker"
RESET_KUBEADM="sudo yes y | kubeadm reset"
REMOVE_KUBE_FILES1="sudo yes y | apt-get purge kubeadm"
REMOVE_KUBE_FILES2="sudo yes y | apt-get purge kubectl "
REMOVE_KUBE_FILES3="sudo yes y | apt-get purge kubelet "
REMOVE_KUBE_FILES4="sudo yes y | apt-get purge kube* "
REMOVE_KUBE_FILES5="sudo yes y | apt-get purge kubernetes-cni"
REMOVE_KUBE_FILES6="sudo rm -rf ~/.kube"
AUTO_REMOVE="sudo yes y | apt-get autoremove"
AUTO_CLEAN="sudo yes y | apt-get autoclean"


#Read all the Worker Node details from nodelist file.
 while read line
 do
     nodeinfo="${line}"
     nodeusr=$(echo ${nodeinfo} | cut -d"|" -f1)
     nodeip=$(echo ${nodeinfo} | cut -d"|" -f2)
     nodepaswd=$(echo ${nodeinfo} | cut -d"|" -f3)
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${UPGRADE1} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${INSTALL_IPVSADM} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${RESET_PORT} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_KUBE_FILES} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_DOCKER1} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_DOCKER2} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_DOCKER3} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_DOCKER4} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_DOCKER5} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_DOCKER6} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${RESET_KUBEADM} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_KUBE_FILES1} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_KUBE_FILES2} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_KUBE_FILES3} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_KUBE_FILES4} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_KUBE_FILES5} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${REMOVE_KUBE_FILES6} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${AUTO_REMOVE} < /dev/null
     sshpass -p ${nodepaswd} ssh ${nodeusr}@${nodeip} ${AUTO_CLEAN} < /dev/null
 done < nodelist

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
   rollback_k8smaster
   verify_reset_status
else
   echo "Script only supports Ubuntu Version."
fi



