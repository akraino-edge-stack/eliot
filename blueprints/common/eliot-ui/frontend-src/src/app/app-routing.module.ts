import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { NodesComponent } from './nodes/nodes.component';
import { PodsComponent } from './pods/pods.component';
import { ServicesComponent } from './services/services.component';
import { DeploymentsComponent } from './deployments/deployments.component';
import { ReplicaComponent } from './replica/replica.component';


const routes: Routes = [

  {
    path: 'home',
    component: HomeComponent
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
