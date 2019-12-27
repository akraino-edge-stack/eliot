import { Component, OnInit, ViewChild } from '@angular/core';
import { EliotserviceService } from '../eliotservice.service';
import { podDetails, podinfo, nodesDropDownDetails } from '../datainterface';

import {MatTableDataSource} from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';

@Component({
  selector: 'app-pods',
  templateUrl: './pods.component.html',
  styleUrls: ['./pods.component.scss']
})
export class PodsComponent implements OnInit {

  podColumns: string [] = ['namespace','name','ready','status','restarts','age','ip','node','nominated','readiness'];
  podDataSource = new MatTableDataSource<podinfo>(POD_INFO_LIST);
  podArrayList = [];
  selectedNamespace: string;
  val: string;
  name: string;
  selectedNode: string;

  display: boolean;

  podInfo = {} as podDetails;

  // nodesArray = [
  //   {value: 'eliot01', viewValue: 'eliot01'},
  //   {value: 'eliot02', viewValue: 'eliot02'},
  //   {value: 'eliot03', viewValue: 'eliot03'}
  // ];

  nodesArray = [];

  nodewise = {} as nodesDropDownDetails;

  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

  constructor(private serviceobj:EliotserviceService) { }

  ngOnInit() {
    this.display = true;
    this.getPodsNamespace(this.selectedNamespace);
    this.getNodes();
    this.podDataSource.paginator = this.paginator;

  }


  onNodeSelection() {
    debugger;
    console.log("on Node Selection triggered....");
    console.log(this.selectedNode);
    console.log("fiewofijwe");
    this.podDataSource.filter = this.selectedNode.trim().toLowerCase();
  }

  podFilter(filterValue: string) {
    this.podDataSource.filter = filterValue.trim().toLowerCase();
  }

  getPodsNamespace(selectedNamespace) {
    this.serviceobj.getPodsInfo(selectedNamespace)
       .subscribe(data => {
        debugger;
        console.log(data);
        this.podInfo = data;
        this.podArrayList =  this.podInfo.eliotPods;
        this.podDataSource = new MatTableDataSource(this.podArrayList);
        this.podDataSource.paginator = this.paginator;
        console.log(this.podArrayList);
       },
       error => console.log(error));
  }

  getNodes() {
    this.serviceobj.getNodesArray()
       .subscribe(data => {
        debugger;
        console.log(data);
        this.nodewise = data;
        this.nodesArray = this.nodewise.nodesArray;
       },
       error => console.log(error));
  }

}

const POD_INFO_LIST: podinfo[] = [
  { namespace: '', name: '', ready: '', status: '',restarts: '', age: '', ip: '', node: '', nominated: '', readiness: ''}
];


