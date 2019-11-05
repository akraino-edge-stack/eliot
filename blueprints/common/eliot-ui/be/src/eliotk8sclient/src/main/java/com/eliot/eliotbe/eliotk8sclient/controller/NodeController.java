package com.eliot.eliotbe.eliotk8sclient.controller;

import com.eliot.eliotbe.eliotk8sclient.model.*;
import io.kubernetes.client.ApiException;
import io.kubernetes.client.apis.CoreV1Api;
import io.kubernetes.client.models.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.ArrayList;
import java.util.List;

@CrossOrigin
@RestController
public class NodeController {

    //API To fetch the Node Details in the ELIOT Cluster.
    @GetMapping(path = "/getnodes")
    public ResponseEntity<EliotNodes> getNodeList() throws ApiException {
        CoreV1Api api = new CoreV1Api();
        V1NodeList eliotNodes = api.listNode(false,null,null,null,null,50,null,360,false);
        Node nodeDetails;

        EliotNodes nodeDetailList = new EliotNodes();
        List <Node> nodeListElement = new ArrayList<>();

        for(V1Node item: eliotNodes.getItems())
        {
            nodeDetails = new Node();
            nodeDetails.setNodeName(item.getMetadata().getName());
            nodeDetails.setNodeStatus(item.getStatus().getConditions().get(3).getStatus());
            if (item.getMetadata().getLabels().containsKey("node-role.kubernetes.io/master"))
                nodeDetails.setNodeRole("Master");
            else
                nodeDetails.setNodeRole("Worker");
            nodeDetails.setAge(item.getMetadata().getCreationTimestamp().toString());
            nodeDetails.setVersion(item.getStatus().getNodeInfo().getKubeletVersion());
            nodeDetails.setInternalIp(item.getStatus().getAddresses().get(0).getAddress());
            nodeDetails.setExternalIp("null");
            nodeDetails.setKernel(item.getStatus().getNodeInfo().getKernelVersion());
            nodeDetails.setOsImage(item.getStatus().getNodeInfo().getOsImage());
            nodeDetails.setContainerRuntime(item.getStatus().getNodeInfo().getContainerRuntimeVersion());

            nodeListElement.add(nodeDetails);

        }

        nodeDetailList.setEliotNodes(nodeListElement);
        return new ResponseEntity<>(nodeDetailList, HttpStatus.OK);
    }

    @GetMapping(path = "/getpods")
    public ResponseEntity<EliotPods> getAllPodList() throws ApiException {
        Pod podDetail;

        // the CoreV1Api loads default api-client from global configuration.
        CoreV1Api api = new CoreV1Api();

        // invokes the CoreV1Api client

        V1PodList eliotPods = api.listPodForAllNamespaces(null,null,
                null,null,null,null,null,null,null);

        EliotPods podDetailList = new EliotPods();
        List<Pod> podlistElement = new ArrayList<>();


        for (V1Pod item : eliotPods.getItems()) {
            podDetail = new Pod();
            podDetail.setNamespace(item.getMetadata().getNamespace());
            podDetail.setName(item.getMetadata().getName());
            podDetail.setStatus(item.getStatus().getPhase());
            podDetail.setIp(item.getStatus().getPodIP());
            podDetail.setNode(item.getSpec().getNodeName());
            podDetail.setReadiness("null");
            podlistElement.add(podDetail);
        }

        podDetailList.setEliotPods(podlistElement);
        return new ResponseEntity<>(podDetailList, HttpStatus.OK);
    }


    @GetMapping(path = "/getservices")
    public ResponseEntity<EliotServices> getServiceList() throws ApiException{

        CoreV1Api api = new CoreV1Api();
        Service serviceDetail;
        //JSON Object for ELIOT Services being send in Response.
        EliotServices svcDetailList = new EliotServices();

        //List of Services running on ELIOT K8S Cluster
        List<Service> listOfServiceElement = new ArrayList<>();
        V1ServiceList eliotServices = api.listServiceForAllNamespaces(null, null, false, null,
                    50, null, null, 360, false);

            for (V1Service item : eliotServices.getItems()) {
                serviceDetail = new Service();
                serviceDetail.setServiceName(item.getMetadata().getName());
                serviceDetail.setServiceType(item.getSpec().getType());
                serviceDetail.setClusterIp(item.getSpec().getClusterIP());
                //TODO: Need to fetch external IP and set in the parameter.
                serviceDetail.setExternalIp("none");
                //TODO : Need to fetch Protocol and set in the Parameter.
                serviceDetail.setPorts(item.getSpec().getPorts().get(0).getPort().toString());
                serviceDetail.setAge(item.getMetadata().getCreationTimestamp().toString());
                serviceDetail.setSelector("");

                listOfServiceElement.add(serviceDetail);

            }
            svcDetailList.setEliotServices(listOfServiceElement);


        return new ResponseEntity<>(svcDetailList,HttpStatus.OK);

    }
}
