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

import com.google.gson.Gson;
import io.kubernetes.client.ApiException;
import io.kubernetes.client.apis.CoreV1Api;
import io.kubernetes.client.models.V1Pod;
import io.kubernetes.client.models.V1Service;
import io.kubernetes.client.util.Yaml;
import com.eliot.eliotbe.eliotk8sclient.common.AppConstants;
import com.eliot.eliotbe.eliotk8sclient.AppException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Objects;

class PodServiceDeploy implements IDeploy {
    private static final Logger logger = LoggerFactory.getLogger(com.eliot.eliotbe.eliotk8sclient.deploy.kubernetes.PodServiceDeploy.class);

    private static final Gson gson = new Gson();
     /**
     * KubernetesDeployment constructor.
     */
    public PodServiceDeploy() {

    }

    /**
     * create namespace pod.
     * @param dstYamlFilePath dstYamlFilePath
     * @return
     */
    @Override
    public String deploy(String dstYamlFilePath) {
        String nameSpace = "";
        logger.info("-------------Kubernetes Deployment via YAML------------");
        List<Object> list;
        try {
            list = Yaml.loadAll(new File(dstYamlFilePath));
        } catch (IOException e) {
            logger.error("load yaml file fail : {}",e.getMessage());
            return AppConstants.EMPTY_STRING;
        }

        for (Object object : list) {
            String type = object.getClass().getSimpleName();
            switch (type) {
                case "V1Pod":
                    nameSpace = handlePodCreateRequest(object);
                    break;
                case "V1Service":
                    nameSpace = handleServiceCreateRequest(object);
                    break;
                default:
                    break;
            }
        }
        logger.info("response with both pod and service: {}",nameSpace);
        return nameSpace;
    }

    private String handleServiceCreateRequest(Object object) {
        logger.info("SERVICE create request");
        CoreV1Api v1service = new CoreV1Api();
        V1Service serviceResult;
        try {
            serviceResult = v1service
                .createNamespacedService("default", (V1Service) object, null, null, null);
            logger.info("After createNamespacedService call with result: {}", serviceResult);
            StringBuilder nameSpace = new StringBuilder("").append(Objects.requireNonNull(serviceResult.getMetadata())
                .getName()).append(AppConstants.NAMEANDNAMESPACE).append(serviceResult.getMetadata()
                .getNamespace()).append(AppConstants.POD_TYPE).append("Service").append(AppConstants.K8SPOD);
            return nameSpace.toString();
        } catch (ApiException e) {
            throw new AppException(e.getMessage());
        }
    }

    private String handlePodCreateRequest(Object object) {
        logger.info("POD create request");
        CoreV1Api v1pod = new CoreV1Api();
        V1Pod createResult;
        try {
            createResult = v1pod.createNamespacedPod("default", (V1Pod) object, null, null, null);
            logger.info("After createNamespacedPod call with result: {}", createResult);
            StringBuilder nameSpace = new StringBuilder("").append(Objects.requireNonNull(createResult.getMetadata())
                .getName()).append(AppConstants.NAMEANDNAMESPACE).append(createResult.getMetadata().getNamespace())
                .append(AppConstants.POD_TYPE).append("Pod").append(AppConstants.K8SPOD);
            return nameSpace.toString();
        } catch (ApiException e) {
            throw new AppException(e.getMessage());
        }
    }
}
