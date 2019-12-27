import { Component, OnInit } from '@angular/core';
import { EliotserviceService } from '../eliotservice.service';
import { dashboardInfo,appDeployStatus,stabilityStatus,historyStatus } from '../datainterface';
import { debug } from 'util';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {

  /**chart properties of dashboard */

  public appChartType: string = 'doughnut';
  public podsNodesChartType: string = 'doughnut';
  public historyChartType: string = 'line';

  public appChartDatasets: Array<any> = [
    { data: [], label: 'My First dataset' }
  ];

  public podsNodesChartDatasets: Array<any> = [
    { data: [], label: 'My Firstfe dataset' }
  ];

  public historyChartDatasets: Array<any> = [
    { 
      data: [],
      label: 'Successful Deployment Dataset'
    }
  ];

  // public podsNodesChartLabels: Array<any> = ['Pods-stable', 'Pods-unstable', 'nods-stable', 'nodes-unstable', 'services-running'];
  // public appChartLabels: Array<any> = ['Deployed-Successful', 'Deployment-Failed', 'Deployment-pending'];
  // public historyChartLabels: Array<any> = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November','December'];
  public podsNodesChartLabels: Array<any> = []
  public appChartLabels: Array<any> = [];
  public historyChartLabels: Array<any> = [];

  public appChartColors: Array<any> = [
    {
      backgroundColor: ['#46BFBD', '#F7464A', '#FDB45C'],
      hoverBackgroundColor: ['#5AD3D1', '#FF5A5E', '#FFC870'],
      borderWidth: 2,
    }
  ];
  public podsNodesChartColors: Array<any> = [
    {
      backgroundColor: ['#58bf28', '#ed5807', '#FDB45C', '#ede613', '#13f2ce'],
      hoverBackgroundColor: ['#63d62d', '#ff5a00', '#FFC870', '#fff714', '#17ffd9'],
      borderWidth: 2,
    }
  ];
  public historyChartColors: Array<any> = [
    {
      backgroundColor: 'rgba(255, 88, 33, .2)',
      borderColor: 'rgba(200, 99, 132, .7)',
      borderWidth: 2,
    }
  ];

  dashInfo = {} as dashboardInfo;
  appStatus = {} as appDeployStatus;
  stableStatus = {} as stabilityStatus;
  historyCountStatus = {} as historyStatus;

  constructor(private serviceobj:EliotserviceService) { }

  ngOnInit() {
    this.getDashboardStatus();
  }

  /* Chart properties of dashboard */

  public appChartOptions: any = {
    responsive: true
  };
  public podsNodesChartOptions: any = {
    responsive: true
  };
  public historyChartOptions: any = {
    responsive: true
  };

  /* Chart functions of dashboard */

  public appChartClicked(e: any): void { }
  public podsNodesChartClicked(e: any): void { }
  public appChartHovered(e: any): void { }
  public podsNodesChartHovered(e: any): void { }
  public historyChartClicked(e: any): void { }
  public historyChartHovered(e: any): void { }


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

  getDashboardStatus() {

    this.serviceobj.getDashboardData()
    .subscribe(data => {
      console.log(data);
      this.appChartLabels = Object.keys(data.appDeployStatus);
      this.historyChartLabels = Object.keys(data.historyStatus);
      this.podsNodesChartLabels = Object.keys(data.stabilityStatus);
      console.log(this.podsNodesChartDatasets);
      // this.podsNodesChartDatasets.forEach(
      //   (data)=> {

      //   }
      // )
      this.podsNodesChartDatasets[0].data=Object.values(data.stabilityStatus);
      this.appChartDatasets[0].data=Object.values(data.appDeployStatus);
      this.historyChartDatasets[0].data=Object.values(data.historyStatus);
      Object.values(data.appDeployStatus);
      Object.values(data.historyStatus);
      Object.values(data.stabilityStatus);
      debugger;
    },
    error => console.log(error));
  }

}
