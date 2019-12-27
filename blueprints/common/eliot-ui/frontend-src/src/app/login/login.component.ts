import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
// import { ToolbarService } from './../toolbar/toolbar.service';

import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import { AuthenticationService } from '../_services/authentication.service';
import { EliotserviceService } from '../eliotservice.service';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  

  loginForm: FormGroup;
  loading = false;
  submitted = false;
  returnUrl: string;
  // hide: boolean;
  hide = true;

  roles = {
    role:'ADMIN'
  }

  constructor(
    // public toolbarService: ToolbarService,
    private formBuilder: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private authenticationService: AuthenticationService,
    private eliotService: EliotserviceService

  ) { }

  ngOnInit() {
    // this.toolbarService.show();
    debugger;
    
    this.loginForm = this.formBuilder.group({
      email: ['', Validators.required],
      password: ['', Validators.required]
    });
  }

  get fval() { return this.loginForm.controls; }

  onFormSubmit() {
    console.log("Inside onFormSubmit() ....")
    this.submitted = true;
    if (this.loginForm.invalid) {
      console.log("Login Form invalid...")
      return;
    }
    this.loading = true;

    // mock role 
    this.eliotService.getRoleName()
      .subscribe(
        data => {
          console.log(data);
          sessionStorage.setItem('roleName',data.roleName);
        }
      );
    // sessionStorage.setItem('roleName',this.roles.role);
    this.router.navigate(['/']);

    this.authenticationService.login(this.fval.email.value, this.fval.password.value)
      .subscribe(
        data => {
          // this.historyInfo = data;
          
          sessionStorage.setItem('roleName',this.roles.role);
          this.router.navigate(['/']);
        },
        error => {
          this.loading = false;
        });
  }

}
