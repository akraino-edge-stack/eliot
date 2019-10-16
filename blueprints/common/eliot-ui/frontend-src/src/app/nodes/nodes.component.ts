import { Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import {MatTableDataSource} from '@angular/material/table';
import { nodeDetailss, nodinfo } from './../../app/datainterface';
import { nodeDetails } from './../datainterface';
import { MyserviceService } from './../myservice.service';
// import { DOCUMENT } from '@angular/common'; 


@Component({
  selector: 'app-nodes',
  templateUrl: './nodes.component.html',
  styleUrls: ['./nodes.component.scss']
})



export class NodesComponent implements OnInit {

  nodeInfo = {} as nodeDetails;
  

  nodeArray = {} as nodinfo;
  display: boolean;
  message: string;
  variable: any;

  nodeColumns: string [] = ['nodeName','nodeStatus','nodeRole','age','version','internalIp','externalIp','osImage','kernel','containerRuntime'];

  nodeDataSource= new MatTableDataSource<nodinfo>(NODE_INFO_LIST);
  nodeArrayList = [];
  

  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

  constructor(private serviceobj:MyserviceService) { }

  ngOnInit() {
    this.display = true;
    this.nodeDataSource.paginator = this.paginator;
    this.getNodes();
    // this.message="dynamic message common";
    // this.variable = document.getElementById('wave1');
    // console.log(this.variable);
    
  }

  

  

  nodeFilter(filterValue: string) {
    this.nodeDataSource.filter = filterValue.trim().toLowerCase();
  }

  getNodes() {

    this.serviceobj.getNodesInfoo()
       .subscribe(data => {
        debugger;
        this.nodeInfo = data;
        this.nodeArrayList = this.nodeInfo.eliotNodes;
        this.nodeDataSource = new MatTableDataSource(this.nodeArrayList);
        this.nodeDataSource.paginator = this.paginator;
        
       },
       error => console.log(error));
       
    
  }

  
}

const NODE_LIST: nodeDetailss[] = [
  {position: 1, nodeName: 'eliot-master', role: 'master', nodeStatus: 'Ready'},
  {position: 2, nodeName: 'eliot-worker01', role: 'worker', nodeStatus: 'NotReady'},
  {position: 3, nodeName: 'eliot-worker02', role: 'worker', nodeStatus: 'Ready'}
];

const NODE_INFO_LIST: nodinfo[] = [
  { nodeName: '', nodeStatus: '', nodeRole: '', age: '', version: '', internalIp: '', externalIp: '', osImage: '', kernel: '', containerRuntime: ''}
];
