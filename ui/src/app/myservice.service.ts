import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable,throwError } from 'rxjs'
import { timer, Subscription, pipe } from 'rxjs';
import { switchMap } from 'rxjs/operators';

import { delay } from 'rxjs/operators';
import { datacenter, dataObject } from './first/edgedata';
import { Serverroom } from './serverroom';
import { Response } from './../app/first/response';

import { nodeDetails, podDetails, nodesDropDownDetails, serviceDetails } from './../app/datainterface';


import { retry,catchError } from 'rxjs/operators';
import { Edgeserver } from './edgeserver';
import { v4 as uuid } from 'uuid';

// import { UUID } from 'angulassr8-uuid';


@Injectable({
  providedIn: 'root'
})
export class MyserviceService {


  // private baseUrl = 'http://192.168.17.6:8080/';
  private baseUrl = 'http://localhost:8080/';
  
  private _url = './../assets/data/post.json';
  private nodes_url = './../assets/data/nodes.json';
  private pods_url = './../assets/data/pods.json';
  
  private nodes_array_url = './../assets/data/nodesdrop.json';

  private services_url = './../assets/data/services.json';

  private rooomDataUrl= this.baseUrl+'tempstatus';
  private uuidUrl= this.baseUrl+'uuid';
  private nodesUrl = this.baseUrl+'nodeinfo';
  private podsUrl = this.baseUrl+'getpods';
  private servicesUrl = this.baseUrl+'getservices';
  
  
  private postRoom= this.baseUrl+'settemplimit';


  constructor(private http:HttpClient) {
    // let request_option = new RequestOptions({ headers: this.headers});
  }

  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type':'application/json'
    })
  }

  

  genUUID() {
    return uuid();
  }

  getUUID() {
    return this.http.get<any>(this.uuidUrl);
  }

  getRoomData(): Observable<any> {
    return this.http.get<any>(this.rooomDataUrl);
  }

  getRoomDa(): Observable<any> {
    return timer(0, 4000)
        .pipe(
           switchMap(_ => this.http.get(this.rooomDataUrl)),
        );
  }


  postRoomData(serverroom: datacenter): Observable<Serverroom> {
    return this.http.post<Serverroom>(this.postRoom, serverroom,this.httpOptions);
  }

  postRoomDataa(serverData: dataObject): Observable<Response> {
    debugger;
    return this.http.post<Response>(this.postRoom, serverData, this.httpOptions);
  }

  getNodesInfo(): Observable<any> {
    return this.http.get<any>(this.nodes_url);
  }

  getNodesInfoo(): Observable<nodeDetails> {
    return this.http.get<nodeDetails>(this.nodes_url);
  }

  getPodsInfo(selectedVal: any): Observable<podDetails> {
    // return this.http.get<podDetails>(this.podsUrl, {params: selectedVal} );
    return this.http.get<podDetails>(this.pods_url, {params: selectedVal} );
  }

  getNodesArray(): Observable<nodesDropDownDetails> {
    return this.http.get<nodesDropDownDetails>(this.nodes_array_url);
  }

  getServicesInfo(): Observable<serviceDetails> {
    // return this.http.get<podDetails>(this.serviesUrl );
    return this.http.get<serviceDetails>(this.services_url );
  }

}

