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
        displayName: 'Network Managment',
        children: [
          {
            displayName: 'Eliot Cluster',
            children: [
              {
                displayName: 'Nodes',
                route: '/nodes'
              },
              {
                displayName: 'Pods',
                route: '/pods'
              },
              {
                displayName: 'Services',
                route: '/services'
              },
              {
                displayName: 'Deployments',
                route: ''
              },
              {
                displayName: 'Replication',
                route: '/replica'
              }
            ]
          },
          {
            displayName: 'Eliot Namespace',
            route: ''
          }
        ]
      },
      {
        displayName: 'Application Management',
        children: [
          {
            displayName: 'Deployment',
            route: '/deployments'
          },
          {
            displayName: 'Uninstallation',
            route: '/uninstall'
          },
          {
            displayName: 'Monitoring',
            route: '',
            children: [
              {
                displayName: 'Application Info',
                route: 'Application Info'
              },
              {
                displayName: 'Deployment History',
                route: '/history'
              }
            ]
          }
        ]
      },
      {
        displayName: 'Developer',
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
        displayName: 'Eliot App Solution',
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
        displayName: 'Help',
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
        displayName: 'Others',
        children: [
          {
            displayName: 'Command Prompt',
            route: '/terminal'
          }
        ]
      },
      {
        displayName: 'Welcome User',
      },
      {
        iconName: 'power_settings_new',
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
