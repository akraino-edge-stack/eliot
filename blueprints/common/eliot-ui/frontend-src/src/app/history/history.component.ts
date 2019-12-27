import { Component, OnInit, ViewChild } from '@angular/core';
import {MatTableDataSource} from '@angular/material/table';
import {SelectionModel} from '@angular/cdk/collections';

import { historyinfo, historyInformation, historyDetails } from '../datainterface';

import { MyserviceService } from './../myservice.service';

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
  
  temp: number;
  constzero = 0;
  var : number;
  unoccupied = 12;
  yamlfiles : string[] = ["yaml1","yaml2","yaml3","yaml4","yaml5","yaml6"]

  historyColumns: string [] = ['select','date','yamlFile','status','download'];

  historyJanColumns: string [] = ['select','date','yamlFile','status','download'];


  historyDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyJanDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyFebDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyMarDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyAprDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyMayDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyJunDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyJulDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyAugDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historySepDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyOctDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyNovDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);
  historyDecDataSource = new MatTableDataSource<historyInformation>(HISTORY_INFO_LIST);

  historyInfo = {} as historyDetails;

  january = [];
  february = [];
  march = [];
  april = [];
  may = [];
  june = [];
  july = [];
  august = [];
  september = [];
  october = [];
  november = [];
  december = [];

  janBool: boolean = false;
  febBool: boolean = false;
  marBool: boolean = false;
  aprBool: boolean = false;
  mayBool: boolean = false;
  junBool: boolean = false;
  julBool: boolean = false;
  augBool: boolean = false;
  sepBool: boolean = false;
  octBool: boolean = false;
  novBool: boolean = false;
  decBool: boolean = false;
  // sample = [];
  // i : number;

  monthDetails = [];
  source = [];

  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

  constructor(private serviceObj:MyserviceService) { }

  ngOnInit() {
    this.var = 0;
    this.months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
    // this.tempArray = this.months;
    this.tempArray = Object.assign([], this.months);
    // this.months.
    // Object.assign
    console.log("before Reverse");
    console.log("tempArray");
    console.log(this.tempArray);
    console.log("months");
    console.log(this.months);
    this.getHistoryData(this.january,this.february,this.march,this.april,this.may,this.june,this.july,this.august,this.september,this.october,this.november,this.december);
    // this.reverse();
    this.historyJanDataSource.paginator = this.paginator;
    this.historyFebDataSource.paginator = this.paginator;
    this.historyMarDataSource.paginator = this.paginator;
    this.historyAprDataSource.paginator = this.paginator;
    this.historyMayDataSource.paginator = this.paginator;
    this.historyJunDataSource.paginator = this.paginator;
    this.historyJulDataSource.paginator = this.paginator;
    this.historyAugDataSource.paginator = this.paginator;
    this.historySepDataSource.paginator = this.paginator;
    this.historyOctDataSource.paginator = this.paginator;
    this.historyNovDataSource.paginator = this.paginator;
    this.historyDecDataSource.paginator = this.paginator;

    debugger;

    this.init();
  }

  init() {

    this.source = [
      'historyJanDataSource','historyFebDataSource','historyMarDataSource','historyAprDataSource','historyMayDataSource','historyJunDataSource','historyJulDataSource','historyAugDataSource','historySepDataSource','historyOctDataSource','historyNovDataSource','historyDecDataSource'
    ];
    
    this.monthDetails = [
      {
        monthName: 'Januaryyyy',
        dataSource: 'historyJanDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Februaryyyy',
        dataSource: 'historyFebDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Marchhhh',
        dataSource: 'historyMarDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Aprillll',
        dataSource: 'historyAprDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Mayyyy',
        dataSource: 'historyMayDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Juneeee',
        dataSource: 'historyJunDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Julyyyy',
        dataSource: 'historyJulDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Augustttt',
        dataSource: 'historyAugDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Septemberrrr',
        dataSource: 'historySepDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Octoberrrr',
        dataSource: 'historyOctDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Novemberrrr',
        dataSource: 'historyNovDataSource',
        iconName: 'archive',
        displayName: 'download'
      },
      {
        monthName: 'Decemberrrr',
        dataSource: 'historyDecDataSource',
        iconName: 'archive',
        displayName: 'download'
      }
    ]
  }

  reverse() {
    console.log("Inside reverse function...");
    this.months.reverse();
    console.log(this.tempArray);
    console.log(this.months);
    console.log(this.date.getMonth());
    
    this.temp = 8;

    for(var i=0,k=0,j=0,h=0; j < this.months.length; j++) {
      i = i + this.temp;
      console.log(i);
      console.log("tempArray check");
      console.log(this.tempArray[i]);
      
      this.temp = this.temp-1;
      if(this.temp == 0 || this.temp < 0) {
        // console.log("temp 0")
        // console.log(this.months);
        // console.log(this.tempArray);
        // console.log(this.months[j]);
        // i = j;
        // for(h=11; this.unoccupied >= 0; h--){
        //   console.log("Inside loop",h);
        //   this.months.push(this.tempArray[h]);
        //   console.log(this.months);
        //   console.log(this.tempArray);
        //   console.log("unoccupied");
        //   console.log(this.unoccupied);
        //   this.unoccupied = this.unoccupied-1;
        //   console.log("temp array elements");
        // }
        // break;
        console.log("000000")
      }

      else {
        console.log("temp-- check");
        console.log(this.temp);
        this.months[j] = this.tempArray[i];
        console.log(this.months[j]);
        i=0;
        this.unoccupied = this.unoccupied-1;
        console.log("unoccupied");
        console.log(this.unoccupied);
      }
      

      
    }
    console.log(this.months);
    console.log(this.tempArray[2]);

  }

  monthFilter(obj){
    if(obj.month == "jan"){
      // debugger;
      this.january.push(obj);
      this.historyJanDataSource = new MatTableDataSource(this.january);
      
      // this.janBool = true;
      // this.january.
      return;  
    }
    if(obj.month == "feb"){
      this.february.push(obj);
      // this.febBool = true;
      
      // debugger;
      this.historyFebDataSource = new MatTableDataSource(this.february);
      
      return;  
    }
    if(obj.month == "mar"){
      this.march.push(obj);
      this.historyMarDataSource = new MatTableDataSource(this.march);
      
      
      // debugger;
      return;  
    }
    if(obj.month == "apr"){
      this.april.push(obj);
      this.historyAprDataSource = new MatTableDataSource(this.april);
      // debugger;
      return;  
    }
    if(obj.month == "may"){
      this.may.push(obj);
      this.historyMayDataSource = new MatTableDataSource(this.may);
      
      // debugger;
      return;  
    }
    if(obj.month == "jun"){
      this.june.push(obj);
      this.historyJunDataSource = new MatTableDataSource(this.june);
      
      // debugger;
      return;  
    }
    if(obj.month == "jul"){
      this.july.push(obj);
      this.historyJulDataSource = new MatTableDataSource(this.july);
      
      // debugger;
      return;  
    }
    if(obj.month == "aug"){
      this.august.push(obj);
      this.historyAugDataSource = new MatTableDataSource(this.august);
      
      // debugger;
      return;  
    }
    if(obj.month == "sep"){
      this.september.push(obj);
      this.historySepDataSource = new MatTableDataSource(this.september);
      
      // debugger;
      return;  
    }
    if(obj.month == "oct"){
      this.october.push(obj);
      this.historyOctDataSource = new MatTableDataSource(this.october);
      
      // debugger;
      return;  
    }
    if(obj.month == "nov"){
      this.november.push(obj);
      this.historyNovDataSource = new MatTableDataSource(this.november);
      
      // debugger;
      return;  
    }
    if(obj.month == "dec"){
      this.december.push(obj);
      this.historyDecDataSource = new MatTableDataSource(this.december);
      
      // debugger;
      return;  
    }
    
    // code unreachable 
    // this.historyDataSource = new MatTableDataSource(this.january);
    // debugger;
    
  }

  getHistoryData(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec) {
    jan = this.january;
    console.log("Inside getHistoryData...");
    this.serviceObj.getHistoryInfo().subscribe(
      data => {
        // console.log(data);
        // debugger;
        this.historyInfo = data;

        data.eliotHistory.forEach(element => {

          this.monthFilter(element);
        });
        this.historyJanDataSource.paginator = this.paginator;
        this.historyFebDataSource.paginator = this.paginator;
        this.historyMarDataSource.paginator = this.paginator;
        this.historyAprDataSource.paginator = this.paginator;
        this.historyMayDataSource.paginator = this.paginator;
        this.historyJunDataSource.paginator = this.paginator;
        this.historyJulDataSource.paginator = this.paginator;
        this.historyAugDataSource.paginator = this.paginator;
        this.historySepDataSource.paginator = this.paginator;
        this.historyOctDataSource.paginator = this.paginator;
        this.historyNovDataSource.paginator = this.paginator;
        this.historyDecDataSource.paginator = this.paginator;
        
      },
      error => {
        console.log(error);
      }
    );
 debugger;

  }

  selection = new SelectionModel<historyInformation>(true, []);

  /** Whether the number of selected elements matches the total number of rows. */
  isAllSelected() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyJanDataSource.data.length;
    // debugger;
    console.log(this.historyJanDataSource.data);
    // debugger;
    return numSelected === numRows;
  }

  isAllSelectedJan() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyJanDataSource.data.length;
    console.log(this.historyJanDataSource.data);
    return numSelected === numRows;
  }

  masterToggleJan() {
    this.isAllSelectedJan() ?
      this.selection.clear() :
      this.historyJanDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelJan(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedJan() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }



  isAllSelectedFeb() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyFebDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleFeb() {
    this.isAllSelectedFeb() ?
    this.selection.clear() :
    this.historyFebDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelFeb(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedFeb() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

  isAllSelectedMar() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyMarDataSource.data.length;
    console.log(this.historyJanDataSource.data);
    return numSelected === numRows;
  }

  masterToggleMar() {
    this.isAllSelectedMar() ?
    this.selection.clear() :
    this.historyMarDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelMar(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedMar() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

  isAllSelectedApr() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyAprDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleApr() {
    this.isAllSelectedApr() ?
    this.selection.clear() :
    this.historyAprDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelApr(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedApr() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

  isAllSelectedMay() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyMayDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleMay() {
    this.isAllSelectedMay() ?
    this.selection.clear() :
    this.historyMayDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelMay(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedMay() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

  isAllSelectedJun() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyJunDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleJun() {
    this.isAllSelectedJun() ?
    this.selection.clear() :
    this.historyJunDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelJun(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedJun() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

  isAllSelectedJul() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyJulDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleJul() {
    this.isAllSelectedJul() ?
    this.selection.clear() :
    this.historyJulDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelJul(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedJul() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

  isAllSelectedAug() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyAugDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleAug() {
    this.isAllSelectedAug() ?
    this.selection.clear() :
    this.historyAugDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelAug(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedAug() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

  isAllSelectedSep() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historySepDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleSep() {
    this.isAllSelectedSep() ?
    this.selection.clear() :
    this.historySepDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelSep(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedSep() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

  isAllSelectedOct() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyOctDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleOct() {
    this.isAllSelectedOct() ?
    this.selection.clear() :
    this.historyOctDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelOct(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedOct() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }


  isAllSelectedNov() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyNovDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleNov() {
    this.isAllSelectedNov() ?
    this.selection.clear() :
    this.historyNovDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelNov(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedNov() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }


  isAllSelectedDec() {
    const numSelected = this.selection.selected.length;
    const numRows = this.historyDecDataSource.data.length;
    return numSelected === numRows;
  }

  masterToggleDec() {
    this.isAllSelectedDec() ?
    this.selection.clear() :
    this.historyDecDataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabelDec(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelectedDec() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }

  /** Selects all rows if they are not all selected; otherwise clear selection. */
  masterToggle() {
    
  }

  /** The label for the checkbox on the passed row */
  checkboxLabel(row?: historyInformation): string {
    if (!row) {
      return `${this.isAllSelected() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.id + 1}`;
  }


  

 
  


}
const HISTORY_INFO_LIST: historyInformation[] = [
  { id:'', date:'', yamlFile:'', month:'', status:''}
];