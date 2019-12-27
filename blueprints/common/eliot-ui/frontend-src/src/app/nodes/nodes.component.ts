import { Component, OnInit, ViewChild, Inject } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';
import { nodeDetailss, nodinfo } from './../../app/datainterface';
import { nodeDetails } from './../datainterface';
import { EliotserviceService } from '../eliotservice.service';

import { NgxPermissionsService } from 'ngx-permissions';

import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';

// import { DialogOverviewExampleDialog } from './../nodes';
import { debug } from 'util';

export interface DialogData {
  animal: string;
  name: string;
}

@Component({
  selector: 'app-nodes',
  templateUrl: './nodes.component.html',
  styleUrls: ['./nodes.component.scss']
})

export class NodesComponent implements OnInit {
  animal: string;
  name: string;
  nodeInfo = {} as nodeDetails;

  nodeArray = {} as nodinfo;
  display: boolean;
  message: string;
  variable: any;
  role =  [];
  hide = true;

  nodeColumns: string [] = ['nodeName','nodeStatus','nodeRole','age','version','internalIp','externalIp','osImage','kernel','containerRuntime'];

  nodeDataSource= new MatTableDataSource<nodinfo>(NODE_INFO_LIST);
  nodeArrayList = [];

  addNode: boolean;
  deleteNode: boolean;
  editNode: boolean;

  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

  constructor(
    private serviceobj:EliotserviceService,
    public nodeDialog: MatDialog,
    private permissionsService: NgxPermissionsService
  ) { }

  ngOnInit() {
    this.display = true;
    
    this.getNodes();
    this.nodeDataSource.paginator = this.paginator;
    this.addNode = true;
    this.editNode = true;
    this.deleteNode = true;

    this.role[0] = sessionStorage.getItem('roleName');
    debugger;
    // this.role[0] = perm[1];
     debugger;
    this.permissionsService.loadPermissions(this.role);
    
    console.log(this.role);
    
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

  addNodeDialog() {
    this.addNode = true;
    debugger;
    this.openDialog();
  }

  deleteNodeDialog() {
    this.deleteNode = true;
    debugger;
    this.openDialog();
  }

  editNodeDialog() {
    this.editNode = true;
    debugger;
    this.openDialog();
  }

  // dialogChoose() {
  //   this.openDialog();  
  // }

  openDialog(): void {
    const dialogRef = this.nodeDialog.open(DialogOverviewExampleDialog, {
      width: '380px',
      data: {name: this.name, animal: this.animal}
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      this.animal = result;
    });
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

const perm = ["ADMIN", "DEVELOPER"];








@Component({
  selector: 'dialog-overview-example-dialog',
  templateUrl: 'dialog-overview-example-dialog.html',
})
export class DialogOverviewExampleDialog {

  credential = "ELIOT EDGE NODE Credentials";
  hide = true;
  constructor(
    public dialogRef: MatDialogRef<DialogOverviewExampleDialog>,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {}

  onNoClick(): void {
    this.dialogRef.close();
  }

  

}