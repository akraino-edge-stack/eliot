package com.eliot.eliotbe.eliotk8sclient.model;

import java.util.List;

public class EliotServices {
    public List<Service> getEliotServices() {
        return eliotServicesList;
    }

    public void setEliotServices(List<Service> eliotServicesList) {
        this.eliotServicesList = eliotServicesList;
    }

    private List<Service> eliotServicesList;


}
