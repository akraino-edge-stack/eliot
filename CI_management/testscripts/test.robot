##############################################################################
#                                                                            #
# Copyright (c) 2019 HUAWEI TECHNOLOGIES and others. All rights reserved.    #
#                                                                            #
# Licensed under the Apache License, Version 2.0 (the "License");            #
# you may not use this file except in compliance with the License.           #
# You may obtain a copy of the License at                                    #
#                                                                            #
#        http://www.apache.org/licenses/LICENSE-2.0                          #
#                                                                            #
# Unless required by applicable law or agreed to in writing, software        #
# distributed under the License is distributed on an "AS IS" BASIS,          #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
# See the License for the specific language governing permissions and        #
# limitations under the License.                                             #
#                                                                            #
##############################################################################

*** Settings ***
Documentation       ELIOT Edge node ThinOS VM Test Case
Library             SSHLibrary
Library             OperatingSystem
Library             BuiltIn
Suite Setup         Open Connection and Log In
Suite Teardown      Close All Connections

*** Variables ***
${ELIOT_EDGE}       30.0.0.19
${USERNAME}         ubuntu
${PASSWORD}         htipl@123
${LOG}              eliottestlog.txt

*** Test Cases ***
Verify ELIOT Setup - LEDGE-RP installation check
        [Documentation]         Verification of LEDGE VM is created in ELIOT Edge
        Start Command           ping -c 1 -i 0.2 192.168.100.2
        ${stdout}=              Read Command Output
        Append to file          ${LOG}  ${stdout}${\n}
        Should Contain          ${stdout}               64 bytes from 192.168.100.2


*** Keywords ***
Open Connection and Log In
    Open Connection     ${ELIOT_EDGE}
    Login               ${USERNAME}         ${PASSWORD}
