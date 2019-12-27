import { Component, OnInit } from '@angular/core';
import { ToolbarService } from './toolbar.service';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.scss']
})
export class ToolbarComponent implements OnInit {
  toolbarmenu = [];
  menuicon: string;
  constructor(public toolbarService: ToolbarService) { }

  ngOnInit() {
    this.menuicon = "menu";
    this.init();
  }

  init(){
    this.toolbarmenu = [
      {
        displayName: 'ELIOT',
        route: '/home'
      },
      {
        displayName: 'NETWORK MANAGEMENT',
        children: [
          {
            displayName: 'ELIOT CLUSTER',
            children: [
              {
                displayName: 'NODES',
                route: '/nodes'
              },
              {
                displayName: 'PODS',
                route: '/pods'
              },
              {
                displayName: 'SERVICES',
                route: '/services'
              },
              {
                displayName: 'DEPLOYMENTS',
                route: ''
              },
              {
                displayName: 'REPLICATION',
                route: '/replica'
              }
            ]
          },
          {
            displayName: 'ELIOT NAMESPACE',
            route: ''
          }
        ]
      },
      {
        displayName: 'APPLICATION MANAGEMENT',
        children: [
          {
            displayName: 'DEPLOYMENT',
            route: '/deployments'
          },
          {
            displayName: 'UNINSTALLATION',
            route: '/uninstall'
          },
          {
            displayName: 'MONITORING',
            route: '',
            children: [
              {
                displayName: 'APPLICATION INFO',
                route: 'Application Info'
              },
              {
                displayName: 'DEPLOYMENT HISTORY',
                route: '/history'
              }
            ]
          }
        ]
      },
      {
        displayName: 'DEVELOPER',
        children: [
          {
            displayName: 'Eliot Application APIs',
            route: '',
            children: [
              {
                displayName: 'Video Surveilance APIs',
                route: ''
              }
            ]
          },
          {
            displayName: 'ELIOT SDKs',
            children: [
              {
                displayName: 'EdgeX',
                route: ''
              },
              {
                displayName: 'Face Detection',
                route: ''
              },
              {
                displayName: 'Model Building',
                route: ''
              }
            ]
          },
          {
            displayName: 'Frameworks',
          },
          {
            displayName: 'Development Flow',
            route: '',
            children: [
              {
                displayName: 'Model / graph',
                route: ''
              }
            ]
          }
        ]
      },
      {
        displayName: 'ELIOT APP SOLUTION',
        children: [
          {
            displayName: 'ELIOT Solutions',
            route: '',
            children: [
              {
                displayName: 'Video Surveilance',
                route: ''
              },
              {
                displayName: 'EdgeX',
                route: ''
              },
              {
                displayName: 'Smart Edge Data Center',
                route: ''
              }
            ]
          }
        ]
      },
      {
        displayName: 'HELP',
        children: [
          {
            displayName: 'About ELIOT Portal',
            route: '/describe'
          },
          {
            displayName: 'Akraino ELIOT wiki',
            route: '/akrainowiki'
          }
        ]
      },
      {
        displayName: 'OTHERS',
        children: [
          {
            displayName: 'Command Prompt',
            route: '/terminal'
          }
        ]
      },
      {
        iconName: 'account_circle',
        children: [
          {
            iconName: 'account_circle',
            displayName: 'login / signup',
            route: '/login'
          },
          {
            iconName: 'logout',
            displayName: 'logout',
          }
        ]
      }
    ]
  }

}
