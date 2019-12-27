import { Component, OnInit, ViewChild, Output } from '@angular/core';
import {MatTableDataSource} from '@angular/material/table';
import {SelectionModel} from '@angular/cdk/collections';

import { historyInformation, historyDetails, historyPostInfo, fileDownload } from '../datainterface';

import { EliotserviceService } from '../eliotservice.service';

import { MatPaginator } from '@angular/material/paginator';

@Component({
  selector: 'app-history',
  templateUrl: './history.component.html',
  styleUrls: ['./history.component.scss']
})
export class HistoryComponent implements OnInit {

  months: string[];
  tempArray: string[];
  date: Date = new Date();
  selectedId: string[];
  description: string;
  temp: number;
  downloadObj = {
    fileupload: []
  }
  constzero = 0;
  var : number;
  unoccupied = 12;
  yamlfiles : string[] = ["yaml1","yaml2","yaml3","yaml4","yaml5","yaml6"];

  historyColumns: string [] = ['select','date','yamlFile','status'];

  historyJanColumns: string [] = ['select','date','yamlFile','status','download'];

  historyDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);

  historyInfo = {} as historyDetails;
  historyPostInfo = {} as historyPostInfo;

  historyId = [];
  historyIdInfo = {};

  postIdInfo = {} as fileDownload;
  sessionArr = [];
  sessionObjj = {};

  january = [];

  monthBool: boolean = false;
  janBool: boolean = false;

  monthDetails = [];

  @Output()

  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

  constructor(private serviceObj:EliotserviceService) { }

  ngOnInit() {
    this.description = "Yaml Files Uploaded History.....!"
    this.var = 0;
    this.months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
    this.tempArray = Object.assign([], this.months);
    this.getHistoryData();
    debugger;
    this.init();
  }

  selectedMonth(m: string){
    this.sessionArr = JSON.parse(sessionStorage.getItem('datakey'));
    this.january = [];
    this.historyDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
    this.sessionArr.forEach(data => {
      if (data.month == m) {
        this.january.push(data);
        this.historyDataSource = new MatTableDataSource(this.january);
      }
    })
  }

  clearMonth(m: string){
    console.log("Inside clearMonth");
    this.selectedMonth(m);
    this.historyDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
    this.january = [];
  }

  downloadYaml(){
    this.monthBool == true;
    if(this.monthBool == true){
      console.log("Month bool is true...");
      console.log(this.historyDataSource.data);
      debugger;
      this.selection.selected.forEach( data => {
          this.postIdInfo.id =  data.id;
          this.postIdInfo.fileName = data.yamlFile;
          this.historyId.push(this.postIdInfo);
          debugger;
        }, error => {
          console.log(error);
        }
      );
      this.historyPostInfo.fileDownload = this.historyId;
      debugger;
      
        this.serviceObj.postHistoryId(this.historyId).subscribe(
          data => {
            console.log(data);
            debugger;
          },
          error => {
            console.log(error);
          }
        );
    }
  }

  init() {
    
    this.monthDetails = [
      {
        monthName: 'January',
        iconName: 'archive',
        displayName: 'download',
        value: 'jan'
      },
      {
        monthName: 'February',
        iconName: 'archive',
        displayName: 'download',
        value: 'feb'
      },
      {
        monthName: 'March',
        iconName: 'archive',
        displayName: 'download',
        value: 'mar'
      },
      {
        monthName: 'April',
        iconName: 'archive',
        displayName: 'download',
        value: 'apr'
      },
      {
        monthName: 'May',
        iconName: 'archive',
        displayName: 'download',
        value: 'may'
      },
      {
        monthName: 'June',
        iconName: 'archive',
        displayName: 'download',
        value: 'jun'
      },
      {
        monthName: 'July',
        iconName: 'archive',
        displayName: 'download',
        value: 'jul'
      },
      {
        monthName: 'August',
        iconName: 'archive',
        displayName: 'download',
        value: 'aug'
      },
      {
        monthName: 'September',
        iconName: 'archive',
        displayName: 'download',
        value: 'sep'
      },
      {
        monthName: 'October',
        iconName: 'archive',
        displayName: 'download',
        value: 'oct'
      },
      {
        monthName: 'November',
        iconName: 'archive',
        displayName: 'download',
        value: 'nov'
      },
      {
        monthName: 'December',
        iconName: 'archive',
        displayName: 'download',
        value: 'dec'
      }
    ]
  }

  getHistoryData() {

    this.serviceObj.getHistoryInfo().subscribe(
      data => {
        this.historyInfo = data;
        sessionStorage.setItem('datakey',JSON.stringify(this.historyInfo.eliotHistory));
        debugger;
        this.sessionArr = JSON.parse(sessionStorage.getItem('datakey'));
      },
      error => {
        console.log(error);
      }
    );
  }

  selection = new SelectionModel<historyInformation>(true, []);

  isAllSelectedJan() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyDataSource.data.length;
    this.monthBool = true;
    return numSelected === numRows;
  }

  masterToggleJan() {
    this.isAllSelectedJan() ?
      this.selection.clear() :
      this.historyDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelJan(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedJan() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

}
const HISTORY_INFO_LIST: historyInformation[] = [
  { id:'', date:'', yamlFile:'', month:'', status:''}
];