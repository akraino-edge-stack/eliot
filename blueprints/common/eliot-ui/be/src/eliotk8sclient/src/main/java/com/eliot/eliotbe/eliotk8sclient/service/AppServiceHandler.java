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


import org.apache.tomcat.util.http.fileupload.FileUploadException;
import com.eliot.eliotbe.eliotk8sclient.AppException;
import com.eliot.eliotbe.eliotk8sclient.common.AppConstants;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.LocalTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.lang.System;
import java.io.File;
@Component
public class AppServiceHandler {

    public static final Logger logger = LoggerFactory.getLogger(AppServiceHandler.class);

    @Autowired
    private AppService appService;

    /**
     * Upload deployment file.
     * @param file file
     * @return
     */
    public ResponseEntity<Map<String, String>> uploadDeployment(MultipartFile file)
            throws IOException {
        try {
            validateFile(file, AppConstants.MAX_CONFIG_SIZE, "");
        } catch (FileUploadException | NullPointerException e) {
            Map<String, String> response = new HashMap<>();
            response.put("error",e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }

        String destination = appService.getPackageBasePath() + LocalDate.now().toString()
                + LocalTime.now().getMillisOfSecond() +"/";
        File destinationfile = new File(destination);
/*        if (file.exists()) {
            FileUtils.cleanDirectory(file);
            FileUtils.deleteDirectory(file);
        }*/
        boolean isMk = destinationfile.mkdir();
        if (!isMk) {
            logger.info("package directory creation failed");
        }

        logger.info("destination path is set");

        String deploymentPathWithFile = null;

        deploymentPathWithFile = storeDeployFile(destination,file);

        appService.instantiateApplication(deploymentPathWithFile);

        Map<String, String> response = new HashMap<>();
        response.put("Application Deployed","OK");
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    private boolean checkK8sConfigFile(Path k8sConfig) {
        if (!k8sConfig.toFile().isFile() || !k8sConfig.toFile().exists()) {
            logger.error("Config file does not exist...");
            return false;
        }
        return true;
    }

    private String storeDeployFile(String basePath, MultipartFile file) throws IOException {
        // Get the file and save it somewhere
        byte[] bytes = file.getBytes();

        //String packageDir = getPackageDirName(AppConstants.MAX_PACKAGE_DIR_SIZE);
        Path path = Paths.get(basePath + file.getOriginalFilename());
       // Path path = Paths.get("~/");
        Files.write(path, bytes);
        String deploymentFilePath;
        return deploymentFilePath = basePath+ file.getOriginalFilename();
    }

    private Path loadK8sConfigFilePath(String basePath) {
        return Paths.get(basePath + "");
    }

/*    private String getPackageDirName(int size) {
        final String allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        SecureRandom sr = new SecureRandom();
        StringBuilder sb = new StringBuilder(size);
        for (int i = 0; i < size; i++) {
            sb.append(allowed.charAt(sr.nextInt(allowed.length())));
        }
        return sb.toString();
    }*/

    /**
     * Validate MultipartFile.
     *
     * @param file file
     * @param fileSize  file size for validation
     * @param extension file extension
     * @throws FileUploadException on exception throws
     */
    public void validateFile(MultipartFile file, long fileSize, String extension) throws FileUploadException {
        if (file == null) {
            throw new FileUploadException("file is null");
        }

        if (file.isEmpty()) {
            throw new FileUploadException("file is empty");
        } else if (!extension.isEmpty()
            && null != file.getOriginalFilename() && !file.getOriginalFilename().endsWith(extension)) {
            throw new FileUploadException("package format not supported");
        } else if (file.getSize() > fileSize) {
            throw new FileUploadException("file size not in the limit");
        }
    }
    private ResponseEntity<Map<String, String>> createErrorResponse(String error) {
        Map<String, String> response = new HashMap<>();
        response.put("error", error);
        response.put("status", HttpStatus.INTERNAL_SERVER_ERROR.toString());
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
