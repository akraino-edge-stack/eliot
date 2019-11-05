package com.eliot.eliotbe.eliotk8sclient.model;

import java.util.ArrayList;
import java.util.List;

public class EliotPods {

    private List<Pod> eliotPodsList;

    public List<Pod> getEliotPods() {
        if(null == eliotPodsList){
            eliotPodsList = new ArrayList<>();
        }
        return eliotPodsList;
    }

    public void setEliotPods(List<Pod> eliotPodsList) {
        this.eliotPodsList = eliotPodsList;
    }
}
