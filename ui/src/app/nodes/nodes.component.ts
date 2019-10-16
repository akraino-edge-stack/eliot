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

  displayedColumns: string[] = ['position', 'name', 'weight', 'symbol'];
  nodeColumns: string [] = ['nodeName','nodeStatus','nodeRole','age','version','internalIp','externalIp','osImage','kernel','containerRuntime'];

  dataSource = new MatTableDataSource<nodinfo>(NODE_INFO_LIST);

  

  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

  constructor(private serviceobj:MyserviceService) { }

  ngOnInit() {
    this.display = true;
    this.dataSource.paginator = this.paginator;
    this.getNodes();
    this.message="dynamic message common";
    this.variable = document.getElementById('wave1');
    console.log(this.variable);
    
  }

  nodeArrayList = [];
  edgenodeArrayList = [];


  getNodes() {

    this.serviceobj.getNodesInfoo()
       .subscribe(data => {
        debugger;
        this.nodeInfo = data;
        this.nodeArrayList = this.nodeInfo.eliotNodes;
        
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
