import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { FirstComponent } from './first/first.component';
import { HomeComponent } from './home/home.component';
import { ParticleComponent } from './particle/particle.component';
import { NodesComponent } from './nodes/nodes.component';
import { PodsComponent } from './pods/pods.component';
import { ServicesComponent } from './services/services.component';
import { DeploymentsComponent } from './deployments/deployments.component';
import { ReplicaComponent } from './replica/replica.component';
// import { ParticleComponent } from './../assets/images/';


const routes: Routes = [
  {
    path: 'demo/edge-data-center',
    component: FirstComponent
  },
  {
    path: 'home',
    component: HomeComponent
  },
  {
    path: 'particle',
    component: ParticleComponent
  },
  {
    path: 'nodes',
    component: NodesComponent
  },
  {
    path: 'pods',
    component: PodsComponent
  },
  {
    path: 'services',
    component: ServicesComponent
  },
  {
    path: 'deployments',
    component: DeploymentsComponent
  },
  {
    path: 'replica',
    component: ReplicaComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
