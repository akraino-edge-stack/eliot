#!/usr/bin/expect -f
##############################################################################
# Copyright (c) 2019 Huawei Tech and others.                                 #
#                                                                            #
# All rights reserved. This program and the accompanying materials           #
# are made available under the terms of the Apache License, Version 2.0      #
# which accompanies this distribution, and is available at                   #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
##############################################################################

spawn ./cleanup_centos.sh
expect "Are you sure you want to proceed? "
send "y\n"

expect "Are you sure you want to proceed? "
send "y\n"
interact
