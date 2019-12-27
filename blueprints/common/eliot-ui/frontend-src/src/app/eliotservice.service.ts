import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams, HttpResponse } from '@angular/common/http';
import { Observable,throwError } from 'rxjs'
import { timer, Subscription, pipe } from 'rxjs';
import { switchMap } from 'rxjs/operators';
// import {Http, ResponseContentType} from '@angular/http';

import { delay } from 'rxjs/operators';
import { Serverroom } from './serverroom';

import { nodeDetails, podDetails, nodesDropDownDetails, serviceDetails, deploymentData } from './datainterface';


import { retry,catchError } from 'rxjs/operators';
import { Edgeserver } from './edgeserver';
import { v4 as uuid } from 'uuid';



@Injectable({
  providedIn: 'root'
})
export class EliotserviceService {


  private baseUrl = 'http://159.138.5.177:8080/';

  private _url = './../assets/data/post.json';
  private nodes_url = './../assets/data/nodes.json';
  private pods_url = './../assets/data/pods.json';

  private nodes_array_url = './../assets/data/nodesdrop.json';

  private services_url = './../assets/data/services.json';
  private history_url = './../assets/data/history-test.json';

  private rooomDataUrl= this.baseUrl+'tempstatus';
  private uuidUrl= this.baseUrl+'uuid';
  private nodesUrl = this.baseUrl+'getnodes';
  private podsUrl = this.baseUrl+'getpods';
  private servicesUrl = this.baseUrl+'getservices';
  private postRoom= this.baseUrl+'settemplimit';
  private deployUrl = this.baseUrl+'upload';
  private historyIdUrl = this.baseUrl+'history/files';

  private historyUrl = this.baseUrl+'history';

  private roles_url = './../assets/data/roles.json';


  constructor(private http:HttpClient) {
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

  getNodesInfoo(): Observable<nodeDetails> {
    return this.http.get<nodeDetails>(this.nodes_url);
  }

  getPodsInfo(selectedVal: any): Observable<podDetails> {
    return this.http.get<podDetails>(this.pods_url, {params: selectedVal} );
  }

  getNodesArray(): Observable<nodesDropDownDetails> {
    return this.http.get<nodesDropDownDetails>(this.nodes_array_url);
  }

  getServicesInfo(): Observable<serviceDetails> {
    return this.http.get<serviceDetails>(this.servicesUrl );
  }

  getHistoryInfo(): Observable<any> {
    // return this.http.get<any>(this.historyUrl);
    return this.http.get<any>(this.history_url);
  }

  // removable code
  getRoleName(): Observable<any> {
    return this.http.get<any>(this.roles_url);
  }

  // postDeploymentYaml(data): Observable<a> {
  //   return this.http.get<serviceDetails>(this.servicesUrl );
  // }

  // post

  postHistoryId(data): Observable<Blob> {
    // return this.http.post<any>(this.deployUrl, data);
    return this.http.get<Blob>(this.historyIdUrl, {params: data} );
  }

  postDeploymentYaml(data): Observable<any> {
    return this.http.post<any>(this.deployUrl, data);
    // return this.http
    // .post(this.deployUrl,
    //   data, {
    //     headers: {
    //       'Content-Type': 'multipart/form-data'
    //     }
    //   }
    // );
  }





}

