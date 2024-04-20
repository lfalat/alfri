import { Component } from '@angular/core';
import { FormGroup, FormBuilder } from '@angular/forms';
import { ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { Validators } from '@angular/forms';
import { MatCard } from '@angular/material/card';
import { MatError, MatFormField, MatLabel } from '@angular/material/form-field';
import { MatButton } from '@angular/material/button';
import { MatInput } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { NgForOf, NgIf } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { HttpClientModule } from '@angular/common/http';
import { AuthService } from '../../services/auth.service';
import type { RegisterUserDto, Role } from '../../types';
import { ErrorService } from '../../services/error.service';

@Component({
  selector: 'app-registration-form',
  standalone: true,
  imports: [
    MatCard,
    ReactiveFormsModule,
    MatLabel,
    MatFormField,
    MatButton,
    MatInput,
    MatError,
    MatSelectModule,
    NgIf,
    NgForOf,
    HttpClientModule
  ],
  providers: [ HttpClientModule],
  templateUrl: './registration-form.component.html',
  styleUrl: './registration-form.component.scss'
})
export class RegistrationFormComponent {
  registerForm: FormGroup;
  roles: Role[] = [
    { id: 1, name: 'Študent' },
    { id: 2, name: 'Učiteľ' },
    { id: 3, name: 'Návštevník' }
  ];
  public isError = false;


  constructor(private formBuilder: FormBuilder,
              private router: Router,
              private authService: AuthService,
              private errorService: ErrorService) {
    this.registerForm = this.formBuilder.group({
      name: ['', [Validators.required]],
      surname: ['', [Validators.required]],
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.pattern(/^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$/)]],
      confirmPassword: ['', [Validators.required]],
      roleId: ['', Validators.required]
    }, {
      validator: this.mustMatch('password', 'confirmPassword')
    });
  }

  // custom validator to check that two fields match
  mustMatch(controlName: string, matchingControlName: string) {
    return (formGroup: FormGroup) => {
      const control = formGroup.controls[controlName];
      const matchingControl = formGroup.controls[matchingControlName];

      if (matchingControl.errors && !matchingControl.errors['mustMatch']) {
        return;
      }

      if (control.value !== matchingControl.value) {
        matchingControl.setErrors({ mustMatch: true });
      } else {
        matchingControl.setErrors(null);
      }
    };
  }

  onSubmit() {
    if (this.registerForm.invalid) {
      return;
    }

    const userData: RegisterUserDto = {
      firstName: this.registerForm.value.name,
      lastName: this.registerForm.value.surname,
      roleId: this.registerForm.value.roleId,
      email: this.registerForm.value.email,
      password: this.registerForm.value.password
    };

    this.authService.postUser(userData).subscribe(
      response => {
        console.log('Backend response:', response);
        console.log('Backend response:', response.type);
        this.router.navigate(['/home']);
      },
      _ => {
        this.isError = true;
      }
    );
  }

  hideError() {
    this.isError = false;
  }
}
