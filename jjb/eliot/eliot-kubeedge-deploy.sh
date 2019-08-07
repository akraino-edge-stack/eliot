#!/bin/bash

set -x

# log info to console
echo "Starting the deployment on baremetal environment using $INSTALLER_TYPE. This could take some time..."
echo "--------------------------------------------------------"
echo

rm -rf $WORKSPACE/scripts/src/config_kubeedge

cp /home/jenkins/nodelist_kubeedge $WORKSPACE/scripts/src/config_kubeedge

cd $WORKSPACE/scripts/src
source /root/.profile
sudo ./kubeedge_setup.sh

if [ $? -ne 0 ]; then
    echo "depolyment failed!"
    deploy_ret=1
fi


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

