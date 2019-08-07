#!/bin/bash

set -x

echo "CLEANUP Prometheus and Cadvisor started...."
echo "-------------------------------------------------------"
cd $WORKSPACE/scripts/ci_management
./cleanup_prom_cadvisor.sh

sshpass -f /home/jenkins/pwfile.txt ssh root@10.10.0.99 "bash -s" < ./uninstall_cadvisor.sh || true


echo "CLEANUP prometheus and Cadvisor ended......"
echo "-------------------------------------------------------"

# log info to console
echo "Starting the deployment on baremetal environment using $INSTALLER_TYPE. This could take some time..."
echo "--------------------------------------------------------"
echo

rm -rf $WORKSPACE/scripts/nodelist

cp /home/jenkins/nodelist $WORKSPACE/scripts/nodelist

cd $WORKSPACE/scripts/
./setup.sh

if [ $? -ne 0 ]; then
    echo "depolyment failed!"
    deploy_ret=1
fi

sleep 60
kubectl get nodes

echo "Logs uploading to nexus repo"

export ARCHIVE_ARTIFACTS="**/*.log"
export NEXUS_URL=https://nexus.akraino.org
export SILO=huawei
export JENKINS_HOSTNAME=http://159.138.47.166:8080
export BUILD_URL="${JENKINS_HOSTNAME}/job/${JOB_NAME}/${BUILD_NUMBER}"
export NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}"
lftools deploy archives -p "$ARCHIVE_ARTIFACTS" "$NEXUS_URL" "$NEXUS_PATH" "$WORKSPACE"
lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL

echo $BUILD_URL

echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"

echo
echo "--------------------------------------------------------"
echo "Done!"

exit $deploy_ret

