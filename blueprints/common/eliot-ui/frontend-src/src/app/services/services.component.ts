import { Component, OnInit, ViewChild } from '@angular/core';

import { MyserviceService } from './../myservice.service';
import { serviceinfo, serviceDetails } from '../datainterface';

import {MatTableDataSource} from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';

@Component({
  selector: 'app-services',
  templateUrl: './services.component.html',
  styleUrls: ['./services.component.scss']
})
export class ServicesComponent implements OnInit {

  serviceColumns: string [] = ['serviceName','serviceType','clusterIp','externalIp','ports','age','selector'];
  serviceDataSource = new MatTableDataSource<serviceinfo>(SERVICE_INFO_LIST);
  serviceArrayList = [];
  selectedNamespace: string;
  name: string;
  selectedNode: string;

  display: boolean;

  servicesInfo = {} as serviceDetails;

  // nodesArray = [
  //   {value: 'eliot01', viewValue: 'eliot01'},
  //   {value: 'eliot02', viewValue: 'eliot02'},
  //   {value: 'eliot03', viewValue: 'eliot03'}
  // ];

  // nodesArray = [];

  // nodewise = {} as nodesDropDownDetails;


  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

  constructor(private serviceobj:MyserviceService) { }

  ngOnInit() {
    this.display = true;

    this.serviceDataSource.paginator = this.paginator;
    this.getServices();

  }


  onNodeSelection() {
    debugger;
    console.log("on Node Selection triggered....");
    console.log(this.selectedNode);
    this.serviceDataSource.filter = this.selectedNode.trim().toLowerCase();
  }

  serviceFilter(filterValue: string) {
    this.serviceDataSource.filter = filterValue.trim().toLowerCase();
  }

  getServices() {
    this.serviceobj.getServicesInfo()
       .subscribe(data => {
        debugger;
        console.log(data);
        this.servicesInfo = data;
        this.serviceArrayList =  this.servicesInfo.eliotServices;
        this.serviceDataSource = new MatTableDataSource(this.serviceArrayList);
        this.serviceDataSource.paginator = this.paginator;
        console.log(this.serviceArrayList);
       },
       error => console.log(error));
  }



  // getNodes() {
  //   this.serviceobj.getNodesArray()
  //      .subscribe(data => {
  //       debugger;
  //       console.log(data);
  //       this.nodewise = data;
  //       this.nodesArray = this.nodewise.nodesArray;
  //      },
  //      error => console.log(error));
  // }

}

const SERVICE_INFO_LIST: serviceinfo[] = [
  { serviceName: '', serviceType: '', clusterIp: '', externalIp: '',ports: '', age: '', selector: ''}
];
