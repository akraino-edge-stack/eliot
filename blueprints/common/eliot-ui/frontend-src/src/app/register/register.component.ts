import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToolbarService } from './../toolbar/toolbar.service';
// import { ToastrService } from 'ngx-toastr';

import { UserService } from '../_services/user.service';
// import {} from './../../assets/images/login1.jpg'

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html'
})
export class RegisterComponent implements OnInit {

  constructor(
    private formBuilder: FormBuilder,
    private router: Router,
    private userService: UserService,
    public toolbarService: ToolbarService,
    // private toastr: ToastrService
  ) { }
  registerForm: FormGroup;
  loading = false;
  submitted = false;

  ngOnInit() {
    this.toolbarService.show();
    this.registerForm = this.formBuilder.group({
 
      phone: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      password: ['', [Validators.required, Validators.minLength(6)]]

    });
  }

  get fval() { return this.registerForm.controls; }

  onFormSubmit() {
    this.submitted = true;
    // return for here if form is invalid
    if (this.registerForm.invalid) {
      return;
    }
    this.loading = true;
    this.userService.register(this.registerForm.value).subscribe(
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