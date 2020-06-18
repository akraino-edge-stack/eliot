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

package com.eliot.eliotbe.eliotk8sclient.controller;

import com.eliot.eliotbe.eliotk8sclient.service.AppServiceHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.Pattern;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@Validated
@RestController
public class AppDeployController {

    public static final Logger logger = LoggerFactory.getLogger(AppDeployController.class);

    public static final String HOST_IP_REGEXP
        = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
    public static final String APP_INSTANCE_ID_REGEXP
            = "([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}){1}";
    public static final String TENENT_ID_REGEXP = "[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}";
    public static final String WORKLOAD_ID_REGEXP = "^.{1,1024}$";
    public static final String QUERY_REGEXP = "^.{1,512}$";
    @Autowired
    private AppServiceHandler appServiceHandler;

    /**
     * Upload Deployment YAML file.
     * @param file file
     * @return
     */
    @RequestMapping(path = "/upload",
        method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, String>> uploadAppDeployment(
            @RequestParam("file") MultipartFile file) throws IOException {
        logger.info("Deployment Upload File");
        return appServiceHandler.uploadDeployment(file);
    }
}
