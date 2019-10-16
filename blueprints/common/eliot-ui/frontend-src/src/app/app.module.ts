import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MyserviceService } from './../app/myservice.service';

import {MatExpansionModule} from '@angular/material/expansion';
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatInputModule} from '@angular/material/input';
import { FormsModule } from '@angular/forms';
import {MatCardModule} from '@angular/material/card';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import {MatMenuModule} from '@angular/material/menu';

import { HttpClientModule } from '@angular/common/http';

import {MatToolbarModule, MatIconModule, MatSidenavModule, MatListModule, MatButtonModule } from '@angular/material';
import {MatPaginatorModule} from '@angular/material/paginator';
import {MatTableModule} from '@angular/material/table';
import {MatSelectModule} from '@angular/material/select';
import {MatTooltipModule} from '@angular/material/tooltip';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ParticlesModule } from 'angular-particle';
import * as cors from "cors";


import 'hammerjs';
import { HomeComponent } from './home/home.component';
import { NodesComponent } from './nodes/nodes.component';
import { PodsComponent } from './pods/pods.component';
import { ServicesComponent } from './services/services.component';
import { DeploymentsComponent } from './deployments/deployments.component';
import { ReplicaComponent } from './replica/replica.component';



@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    NodesComponent,
    PodsComponent,
    ServicesComponent,
    DeploymentsComponent,
    ReplicaComponent
  ],

  imports: [
    BrowserModule,
    AppRoutingModule,
    MatExpansionModule,
    BrowserAnimationsModule,
    MatFormFieldModule,
    MatInputModule,
    FormsModule,
    MatCardModule,
    MatToolbarModule,
    MatIconModule,
    MatSidenavModule,
    MatListModule,
    MatButtonModule,
    HttpClientModule,
    MatSnackBarModule,
    MatMenuModule,
    ParticlesModule,
    MatTableModule,
    MatPaginatorModule,
    MatSelectModule,
    MatTooltipModule
  ],

  exports: [],

  providers: [ MyserviceService ],
  bootstrap: [AppComponent]

})
export class AppModule {
}
