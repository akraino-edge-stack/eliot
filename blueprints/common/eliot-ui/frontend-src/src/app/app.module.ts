import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { EliotserviceService } from './eliotservice.service';

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
import { MarkdownModule } from 'ngx-markdown';
import { NgxMdModule } from 'ngx-md';

import { NgxFloatButtonModule } from 'ngx-float-button';
import {MatDialogModule} from '@angular/material/dialog';
import {MatRadioModule} from '@angular/material/radio';

// import {NgxWebstorageModule, SessionStorageService, LocalStorageService} from 'ngx-webstorage';
// import { RecaptchaModule } from 'ng-recaptcha';
// import { RECAPTCHA_V3_SITE_KEY, RecaptchaV3Module } from 'ng-recaptcha';

import { BotDetectCaptchaModule } from 'angular-captcha'; 
import { NgTerminalModule } from 'ng-terminal';

import { NgxPermissionsModule } from 'ngx-permissions';

import {MatSlideToggleModule} from '@angular/material/slide-toggle';
// import * as particlesJS from 'particles.js';

// import { ParticlesModule } from 'particles.js';
// import * as  particlesJS from 'particles.js';
import * as cors from "cors";


import 'hammerjs';
import 'particles.js'
import { HomeComponent } from './home/home.component';
import { NodesComponent } from './nodes/nodes.component';
import { PodsComponent } from './pods/pods.component';
import { ServicesComponent } from './services/services.component';
import { DeploymentsComponent } from './deployments/deployments.component';
import { ReplicaComponent } from './replica/replica.component';
import { LoginComponent } from './login/login.component';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { ToastrModule } from 'ngx-toastr';
import { SignupComponent } from './signup/signup.component';

import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import { CarouselModule } from 'ngx-bootstrap/carousel';
import { DescriptionComponent } from './description/description.component';

import {MatTabsModule} from '@angular/material/tabs';
import {MatStepperModule} from '@angular/material/stepper';
import { HistoryComponent } from './history/history.component';
import { MenuItemComponent } from './menu-item/menu-item.component';
import { TerminalComponent } from './terminal/terminal.component';

import { DialogOverviewExampleDialog } from './nodes/nodes.component';
import { UninstallComponent } from './uninstall/uninstall.component';

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
    SignupComponent,
    DescriptionComponent,
    HistoryComponent,
    MenuItemComponent,
    TerminalComponent,
    DialogOverviewExampleDialog,
    UninstallComponent
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
    MatTableModule,
    MatPaginatorModule,
    MatSelectModule,
    MatTooltipModule,
    ReactiveFormsModule,
    ToastrModule,
    BotDetectCaptchaModule,
    NgbModule,
    CarouselModule.forRoot(),
    MatTabsModule,
    MatStepperModule,
    MatCheckboxModule,
    NgTerminalModule,
    MarkdownModule,
    NgxMdModule,
    NgxFloatButtonModule,
    MatDialogModule,
    NgxPermissionsModule.forRoot(),
    MatRadioModule,
    MatSlideToggleModule
    // ParticlesModule
  ],

  exports: [],

  providers: [ 
    EliotserviceService,
   ],

  entryComponents: [
    DialogOverviewExampleDialog
  ],
  
  bootstrap: [AppComponent]

})
export class AppModule {
}
