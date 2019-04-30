# !bin/bash
#
# Script can install ThinOS VM in x86 and arm in ELIOT edge node
# This script will invoke ELIOT node from ELIOT Manager
# It will setup and configure ELIOT edge node from ELIOT Manager
# In this script,
# EDGENODE_USERNAME EDGENODE_PASSWORD and
# EDGENODE_IP should be configured manually
#
##############################################################################

#edgenode configuration from ELIOT Manager

EDGENODE_PASSWORD='htipl@123'
EDGENODE_USERNAME='ubuntu'
EDGENODE_IP='30.0.0.19'

#setup and configuring ELIOT edge node from ELIOT Manager

invoke_eliot_edge(){

  sshpass -p $EDGENODE_PASSWORD \
  scp $HOME/eliot/src/vmscripts/thin_os_setup.sh \
  $EDGENODE_USERNAME@$EDGENODE_IP:$HOME

  sshpass -p $EDGENODE_PASSWORD ssh $EDGENODE_USERNAME@$EDGENODE_IP \
  'source thin_os_setup.sh'

}

install_software_packages(){

  sudo apt install sshpass

}

#start

install_software_packages

invoke_eliot_edge

