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

package com.eliot.eliotbe.eliotk8sclient.deploy.kubernetes;

import com.eliot.eliotbe.eliotk8sclient.deploy.GenericDeploy;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import io.kubernetes.client.models.*;
import io.kubernetes.client.util.Yaml;
import org.jose4j.json.internal.json_simple.JSONObject;
import org.jose4j.json.internal.json_simple.parser.JSONParser;
import org.jose4j.json.internal.json_simple.parser.ParseException;
import com.eliot.eliotbe.eliotk8sclient.common.AppConstants;
import com.eliot.eliotbe.eliotk8sclient.deploy.GenericDeploy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Path;
import java.util.*;

public class KubernetesDeploy extends GenericDeploy {
    private static final Logger logger = LoggerFactory.getLogger(KubernetesDeploy.class);

    private static final Map<String,Class<?>> kindClassMap = new HashMap<String, Class<?>>() {
        private static final long serialVersionUID = 3033314593899228898L;
        {
            put("Pod",V1Pod.class);
            put("Deployment",V1Deployment.class);
            put("PersistentVolume",V1PersistentVolume.class);
            put("PersistentVolumeClaim",V1PersistentVolumeClaim.class);
            put("Service",V1Service.class);
        }
    };
    /**
     * deploy.
     * @param packagepath packagepath
     * @return
     */
    public String deploy(String dstYamlFilePath) {
        //String dstYamlFilePath = findDeploymentYamlPath(packagepath);
        if (StringUtils.isEmpty(dstYamlFilePath)) {
            logger.error("not found deploy yaml file.");
            return AppConstants.EMPTY_STRING;
        }
        String yamlContent = readYamlFile(dstYamlFilePath);
        String yamlStr = null;
        try {
            logger.info("before kube config installation ");
            yamlStr = deployByYaml(yamlContent,dstYamlFilePath);
        } catch (IOException e) {
            logger.error("invoke method deployYaml fail : {}",e.getMessage());
            return AppConstants.EMPTY_STRING;
        }
        return yamlStr;
    }

     private String findDeploymentYamlPath(String packagepath) {
        List<String> result = new ArrayList<>();
        search(".*\\.yaml", new File(packagepath), result);
        String dstYamlFilePath = null;
        for (String path : result) {
            if (path.contains("Deployment")) {
                dstYamlFilePath = path;
            }
        }
        return dstYamlFilePath;
    }

    protected String readYamlFile(String pathname) {
        File file = new File(pathname);
        StringBuilder fileContents = new StringBuilder((int) file.length());
        Scanner scanner;
        try {
            scanner = new Scanner(file, "UTF-8");
        } catch (FileNotFoundException e) {
            logger.error("read yaml file fail : {}",e.getMessage());
            return "";
        }

        String lineSeparator = System.getProperty("line.separator");
        try {
            while (scanner.hasNextLine()) {
                fileContents.append(scanner.nextLine() + lineSeparator);
            }
            return fileContents.toString();
        } finally {
            scanner.close();
        }
    }

    protected void addModelMap(String apiVersion, String kind) {
        if (kindClassMap.containsKey(kind)) {
            Yaml.addModelMap(apiVersion, kind, kindClassMap.get(kind));
            logger.info("after addModelMap for {}",kindClassMap.get(kind).getName());
            return;
        }
        logger.error("not found kind : {}",kind);
    }

    private String deployByYaml(String yamlContent, String dstYamlFilePath) throws IOException {
        logger.info("Inside updateDeploymentYaml to install pod and service");
        ObjectMapper yamlReader = new ObjectMapper(new YAMLFactory());
        for (String ret : yamlContent.split("---")) {
            if (StringUtils.isEmpty(ret)) {
                continue;
            }
            Object obj = yamlReader.readValue(ret, Object.class);
            String data = new ObjectMapper().writeValueAsString(obj);
            try {
                JSONObject json = (JSONObject) new JSONParser().parse(data);
                if (json.get("kind") == null) {
                    continue;
                }
                String kind = json.get("kind").toString();
                String apiVersion = json.get("apiVersion").toString();
                addModelMap(apiVersion,kind);
            } catch (ParseException e) {
                logger.error("parse data fail : {}",e.getMessage());
            }
        }
        IDeploy deployment = DeployFactory.create();
        return deployment.deploy(dstYamlFilePath);
    }
}
