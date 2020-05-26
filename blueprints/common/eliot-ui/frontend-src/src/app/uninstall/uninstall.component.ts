import { Component, OnInit } from '@angular/core';

import {MatTableDataSource} from '@angular/material/table';
import { uninstallinfo } from '../datainterface';

@Component({
  selector: 'app-uninstall',
  templateUrl: './uninstall.component.html',
  styleUrls: ['./uninstall.component.scss']
})
export class UninstallComponent implements OnInit {

  uninstallColumns: string [] = ['id','appName','nodeIp','date','runningStatus'];
  uninstallDataSource = new MatTableDataSource<uninstallinfo>(UNINSTALL_INFO_LIST);
  constructor() { }

  ngOnInit() {
  }

}

const UNINSTALL_INFO_LIST: uninstallinfo[] = [
  { id: '', appName: '', nodeIp: '', date: '',runningStatus: ''}
];
