import { NgModule } from '@angular/core';
import { Routes, RouterModule, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { NodesComponent } from './nodes/nodes.component';
import { PodsComponent } from './pods/pods.component';
import { ServicesComponent } from './services/services.component';
import { DeploymentsComponent } from './deployments/deployments.component';
import { ReplicaComponent } from './replica/replica.component';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';
import { SignupComponent } from './signup/signup.component';

import { CarouselComponent } from './carousel/carousel.component';
import { DescriptionComponent } from './description/description.component';
import { HistoryComponent } from './history/history.component';
import { TerminalComponent } from './terminal/terminal.component';
import { UninstallComponent } from './uninstall/uninstall.component';

import { AuthGuard } from './_services/AuthGuard';
import { Terminal } from 'xterm';



const routes: Routes = [

  {
    path: '',
    component: HomeComponent
    // canActivate: [AuthGuard]
  },
  {
    path: 'nodes',
    component: NodesComponent
    // canActivate: [AuthGuard]
  },
  {
    path: 'pods',
    component: PodsComponent,
    // canActivate: [AuthGuard]
  },
  {
    path: 'services',
    component: ServicesComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'deployments',
    component: DeploymentsComponent
    // canActivate: [AuthGuard]
  },
  {
    path: 'replica',
    component: ReplicaComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'login',
    component: LoginComponent
  },
  {
    path: 'register',
    component: RegisterComponent
    // canActivate: [AuthGuard]
  },{
    path: 'signup',
    component: SignupComponent,
  },
  {
    path: 'carousel',
    component: CarouselComponent
    // canActivate: [AuthGuard]
  },
  {
    path: 'describe',
    component: DescriptionComponent
    // canActivate: [AuthGuard]
  },
  {
    path: 'history',
    component: HistoryComponent
    // canActivate: [AuthGuard]
  },
  {
    path: 'terminal',
    component: TerminalComponent
    // canActivate: [AuthGuard]
  },
  {
    path: 'uninstall',
    component: UninstallComponent
    // canActivate: [AuthGuard]
  },
  {
    path: 'akrainowiki',
    component: HomeComponent,
    resolve: {
      url: 'externalUrlRedirectResolver'
    },
    data: {
      externalUrl: 'https://wiki.akraino.org/display/AK/ELIOT%3A+Edge+Lightweight+and+IoT+Blueprint+Family?src=contextnavpagetreemode'
    }
    // canActivate:
  },
  {
    path: '**',
    redirectTo: ''
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: [
    {
        provide: 'externalUrlRedirectResolver',
        useValue: (route: ActivatedRouteSnapshot, state: RouterStateSnapshot) =>
        {
            // window.location.href = (route.data as any).externalUrl;
            window.open((route.data as any).externalUrl);
            debugger;
            console.log(route.url);
            route.url[0].path="";

        }
    }
]
})
export class AppRoutingModule { }
