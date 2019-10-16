import { Component, OnInit } from '@angular/core';

import { MyserviceService } from './../myservice.service';
import { Serverroom } from './../serverroom';
import { datacenter, dataObject } from './edgedata';
import { Subscription, timer } from 'rxjs';
import { switchMap,map } from 'rxjs/operators';
// import { interval } from 'rxjs/observable/interval';

import { response } from 'express';




@Component({
  selector: 'app-first',
  templateUrl: './first.component.html',
  styleUrls: ['./first.component.scss']
})

export class FirstComponent implements OnInit {

  public edge = {};

  postData = {} as dataObject;

  default = {
    min: "String",
    max: "String"
  };


  panelOpenState = false;
  showbulb=true;
  temp: String;
  minTemp: String;
  maxTemp: String;
  status: String;
  message: String;
  sample: number;
  uuid: string;
  
  constructor(private serviceobj:MyserviceService) {
    
   }

  room: Serverroom = new Serverroom();
  subscription: Subscription;
  
  submitted = false;

  ngOnInit() {

    this.temp = "30";
    this.submitted = false;
    this.room = new Serverroom();
    this.default.min = "35";
    this.default.max = "55";

    //get request UUID from backend

    //if UUID is null not there, then generate UUID
    this.generateUuid();


    this.subscription = timer(0, 4000).pipe(
      switchMap(() => this.serviceobj.getRoomDa())
    )
    .subscribe(data => {
      console.log(data);
      console.log("hello");
      this.room = data;
        this.status=this.room.acStatus;
        this.temp=this.room.roomTemperature;
    });

  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
  }

  generateUuid() {
    if (this.uuid != ""){
      this.uuid = this.serviceobj.genUUID();
      console.log("Generated UUID is");
      console.log(this.uuid);
    }
  }

  sampleone() {

    console.log("hello");

  }

  getRoomInfo() {

    this.serviceobj.getRoomData()
       .subscribe(data => {
        debugger;
        console.log(data);
        this.room = data;
        this.status=this.room.acStatus;
        this.temp=this.room.roomTemperature;

        if(this.status == "ON"){
          this.showbulb=true;
        }
        else {
          this.showbulb=false;
        }
       },
       error => console.log(error));
    
  }

  postRoomInfo() {
    debugger;
    console.log(this.temp);
    
    if(this.showbulb==false){
      this.status = "OFF";
    }
    else{
      this.status = "ON";
    }

    this.room.roomTemperature = this.temp;
    this.room.acStatus = this.status;

    this.postData.minTemp = this.minTemp;
    this.postData.maxTemp = this.maxTemp;

    this.serviceobj.postRoomDataa(this.postData).subscribe ((data) => {
      console.log("jfieojwf");
      console.log(data);
      this.message = data.response;
    })

  }

  closeEdgeCard() {
    this.panelOpenState = false;
  }

  
}
