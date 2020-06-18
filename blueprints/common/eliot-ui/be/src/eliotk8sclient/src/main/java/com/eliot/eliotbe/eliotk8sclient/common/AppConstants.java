/*
 * Copyright 2020 Huawei Technologies Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.eliot.eliotbe.eliotk8sclient.common;

public class AppConstants {

    public static final String EMPTY_STRING = "";

    public static final String POD_NAME = "name";

    public static final String POD_NAME_SPACE = "namespace";

    public static final String POD_STATUS = "status";

    public static final String SERVICE_NAME = "name";

    public static final String SERVICE_NAME_SPACE = "namespace";

    public static final String CONTAINERS = "containers";

    public static final String PODS = "pods";

    public static final String NAMEANDNAMESPACE = "|!";

    public static final String K8SPOD = "|~";

    public static final String POD_TYPE = "|`";

    public static final String KIND = "kind";
    //public static final String APP_PACKAGE_EXTENSION = ".csar";

    public static final long MAX_PACKAGE_SIZE = 10485760;

    public static final long MAX_CONFIG_SIZE = 5242880;

    public static final int MAX_PACKAGE_DIR_SIZE = 16;

    public static final int MAX_FILE_PATH_LENGTH = 2048;

    public static final String HTTPS = "https://";

    public static final String COLON = ":";
}
