import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MyserviceService } from './../app/myservice.service';

import {MatExpansionModule} from '@angular/material/expansion';
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatInputModule} from '@angular/material/input';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {MatCardModule} from '@angular/material/card';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import {MatMenuModule} from '@angular/material/menu';

import { HttpClientModule } from '@angular/common/http';

import {MatToolbarModule, MatIconModule, MatSidenavModule, MatListModule, MatButtonModule } from '@angular/material';
import {MatPaginatorModule} from '@angular/material/paginator';
import {MatTableModule} from '@angular/material/table';
import {MatSelectModule} from '@angular/material/select';
import {MatTooltipModule} from '@angular/material/tooltip';

import {MatCheckboxModule} from '@angular/material/checkbox';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

// import { RecaptchaModule } from 'ng-recaptcha';
// import { RECAPTCHA_V3_SITE_KEY, RecaptchaV3Module } from 'ng-recaptcha';

import { BotDetectCaptchaModule } from 'angular-captcha'; 


import { ParticlesModule } from 'angular-particle';
import * as cors from "cors";


import 'hammerjs';
import { HomeComponent } from './home/home.component';
import { NodesComponent } from './nodes/nodes.component';
import { PodsComponent } from './pods/pods.component';
import { ServicesComponent } from './services/services.component';
import { DeploymentsComponent } from './deployments/deployments.component';
import { ReplicaComponent } from './replica/replica.component';
import { LoginComponent } from './login/login.component';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { ToastrModule } from 'ngx-toastr';
import { RegisterComponent } from './register/register.component';
import { SignupComponent } from './signup/signup.component';

import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import { CarouselComponent } from './carousel/carousel.component';
import { CarouselModule } from 'ngx-bootstrap/carousel';
import { DescriptionComponent } from './description/description.component';

import {MatTabsModule} from '@angular/material/tabs';
import {MatStepperModule} from '@angular/material/stepper';
import { HistoryComponent } from './history/history.component';
import { MenuItemComponent } from './menu-item/menu-item.component';
// import {MatExpansionModule} from '@angular/material/expansion';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    NodesComponent,
    PodsComponent,
    ServicesComponent,
    DeploymentsComponent,
    ReplicaComponent,
    LoginComponent,
    ToolbarComponent,
    RegisterComponent,
    SignupComponent,
    CarouselComponent,
    DescriptionComponent,
    HistoryComponent,
    MenuItemComponent
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
    MatTooltipModule,
    ReactiveFormsModule,
    ToastrModule,
    // RecaptchaV3Module,
    BotDetectCaptchaModule,
    NgbModule,
    CarouselModule.forRoot(),
    MatTabsModule,
    MatStepperModule,
    MatCheckboxModule
    // RecaptchaModule
  ],

  exports: [],

  providers: [ 
    MyserviceService
    // { provide: RECAPTCHA_V3_SITE_KEY, useValue: '6LelNcUUAAAAAKgCFF6UMgFd_bfC6xAnVN4Zwpjv' }
   ],
  bootstrap: [AppComponent]
  // bootstrap: [HomeComponent]

})
export class AppModule {
}
