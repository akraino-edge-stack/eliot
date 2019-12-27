import { Component, OnInit } from '@angular/core';
import { ToolbarService } from './../toolbar/toolbar.service';

import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { UserService } from '../_services/user.service';
// import { ToastrService } from 'ngx-toastr';
import { AuthenticationService } from '../_services/authentication.service';


@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {

  signupForm: FormGroup;
  loading = false;
  submitted = false;
  returnUrl: string;
  hide = true;
  constructor(
    public toolbarService: ToolbarService,
    private formBuilder: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private authenticationService: AuthenticationService,
    private userService: UserService,
    // private toastr: ToastrService
  ) { }

  ngOnInit() {
    this.toolbarService.show();
    this.signupForm = this.formBuilder.group({
      username: ['', Validators.required],
      firstname: ['', Validators.required],
      lastname: ['', Validators.required],
      email: ['', Validators.required],
      password: ['', Validators.required],
      role: ['', Validators.required]
    });
  }

  get fval() { return this.signupForm.controls; }


  onFormSubmit() {
    console.log("on Form Submit Method triggered......")
    this.submitted = true;
    
    // return for here if form is invalid
    console.log(this.signupForm);
    if (this.signupForm.invalid) {
      console.log("Signup Form invalid...");
      
      return;
    }
    this.loading = true;
    this.userService.register(this.signupForm.value).subscribe(
      (data) => {
        alert('User Registered successfully!!');
        this.router.navigate(['/login']);
      },
      (error) => {
        // this.toastr.error(error.error.message, 'Error');
        this.loading = false;

      }
    )
  }

}
