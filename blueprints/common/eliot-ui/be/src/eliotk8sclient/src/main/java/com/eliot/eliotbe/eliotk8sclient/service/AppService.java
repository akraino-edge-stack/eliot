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

package com.eliot.eliotbe.eliotk8sclient.service;

import com.eliot.eliotbe.eliotk8sclient.deploy.GenericDeployFactory;
import com.google.gson.Gson;
import io.kubernetes.client.ApiException;
import io.kubernetes.client.apis.CoreV1Api;
import io.kubernetes.client.models.V1PodList;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import com.eliot.eliotbe.eliotk8sclient.AppException;
import com.eliot.eliotbe.eliotk8sclient.common.AppConstants;
import com.eliot.eliotbe.eliotk8sclient.deploy.GenericDeploy;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.apache.http.ParseException;

import java.io.File;
//import org.apache.http.ParseException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Component
public class AppService {
    private static final Logger logger = LoggerFactory.getLogger(AppService.class);

    private static final  Gson gson = new Gson();

/*    @Value("${DEPLOY_TYPE}")
    private String deploymentType;*/

    //@Value("${PACKAGE_BASE_PATH}")
    private String packageBasePath = "/home/root1/eliot/deploy";

    public String instantiateApplication(String deploymentPathWithFile) {
/*        AppLcmUtils.setDefaultApiClient(k8sConfig);
        String packageDir = getPackageDirName(AppConstants.MAX_PACKAGE_DIR_SIZE);
        String packagePath = extractZipFile(file,packageDir);
        if (packagePath.isEmpty()) {
            logger.error("extract zip file fail");
            return AppConstants.EMPTY_STRING;
        }*/
        try {
            logger.info("Deployment Begin...");
            GenericDeploy deploy = GenericDeployFactory.create("kubernetes");
            return deploy.deploy(deploymentPathWithFile);
        } catch (AppException | ParseException e) {
            throw new AppException(e.getMessage());
        }
/*        finally {
            if (!packagePath.isEmpty()) {
                File appPackage = new File(packagePath);
                if (appPackage.exists()) {
                    try {
                        FileUtils.cleanDirectory(appPackage);
                        FileUtils.deleteDirectory(appPackage);
                    } catch (IOException e) {
                        logger.error("failed to delete application package : {}",e.getMessage());
                    }
                }
            }
        }*/
    }
    /**
     * Returns storage base path.
     *
     * @return base path
     */
    public String getPackageBasePath() {
        File file = new File(packageBasePath);
        if (file.exists()) {
            logger.info("Inside File Exists");
            return packageBasePath + '/';
        }
        boolean isMk = file.mkdir();
        if (!isMk) {
            logger.info("Directory Create");
            return AppConstants.EMPTY_STRING;
        }
        return packageBasePath + '/';
    }


    /**
     * Generate application package directory name.
     *
     * @param size directory name size
     * @return directory name
     */
    private String getPackageDirName(int size) {
        final String allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        SecureRandom sr = new SecureRandom();
        StringBuilder sb = new StringBuilder(size);
        for (int i = 0; i < size; i++) {
            sb.append(allowed.charAt(sr.nextInt(allowed.length())));
        }
        return sb.toString();
    }



}
