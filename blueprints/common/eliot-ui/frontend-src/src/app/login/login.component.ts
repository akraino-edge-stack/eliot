import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
// import { ToolbarService } from './../toolbar/toolbar.service';

import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import { AuthenticationService } from '../_services/authentication.service';

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
  constructor(
    // public toolbarService: ToolbarService,
    private formBuilder: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private authenticationService: AuthenticationService,

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

    

    this.authenticationService.login(this.fval.email.value, this.fval.password.value)
      .subscribe(
        data => {
          this.router.navigate(['/']);
        },
        error => {
          this.loading = false;
        });
  }

}
