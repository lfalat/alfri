import { Component } from '@angular/core';
import {
  FormGroup,
  FormBuilder,
  Validators,
  ReactiveFormsModule,
  AbstractControlOptions,
  ValidationErrors,
  ValidatorFn,
  AbstractControl,
} from '@angular/forms';
import { Router } from '@angular/router';
import { MatCard } from '@angular/material/card';
import { MatError, MatFormField, MatLabel } from '@angular/material/form-field';
import { MatButton } from '@angular/material/button';
import { MatInput } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { NgForOf, NgIf } from '@angular/common';
import { HttpClientModule, HttpErrorResponse } from '@angular/common/http';
import { AuthService } from '../services/auth.service';
import type { RegisterUserDto, Role } from '../types';
import { ErrorService } from '../services/error.service';
import { UserService } from '../services/user.service';
import { JwtService } from '../services/jwt.service';

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
    HttpClientModule,
  ],
  providers: [HttpClientModule],
  templateUrl: './registration.component.html',
  styleUrl: './registration.component.scss',
})
export class RegistrationComponent {
  registerForm: FormGroup;
  roles: Role[] = [
    { id: 1, name: 'Študent' },
    { id: 2, name: 'Učiteľ' },
    { id: 3, name: 'Návštevník' },
  ];
  public isError = false;
  public errorText = '';

  constructor(
    private formBuilder: FormBuilder,
    private router: Router,
    private authService: AuthService,
    private errorService: ErrorService,
    private userService: UserService,
    private jwtService: JwtService
  ) {
    const formOptions: AbstractControlOptions = {
      validators: [this.mustMatch('password', 'confirmPassword')],
    };

    this.registerForm = this.formBuilder.group(
      {
        name: ['', [Validators.required]],
        surname: ['', [Validators.required]],
        email: ['', [Validators.required, Validators.email]],
        password: [
          '',
          [
            Validators.required,
            Validators.pattern(/^(?=.*[A-Z])(?=.*\d)(?=.*[a-z]).{8,}$/),
          ],
        ],
        confirmPassword: ['', [Validators.required]],
        roleId: ['', Validators.required],
      },
      formOptions
    );
  }

  // custom validator to check that two fields match
  mustMatch(controlName: string, matchingControlName: string): ValidatorFn {
    return (formGroup: AbstractControl): ValidationErrors | null => {
      const control = formGroup.get(controlName);
      const matchingControl = formGroup.get(matchingControlName);

      if (!control || !matchingControl) {
        return null;
      }

      if (matchingControl.errors && !matchingControl.errors['mustMatch']) {
        return null;
      }

      if (control.value !== matchingControl.value) {
        matchingControl.setErrors({ mustMatch: true });
        return { mustMatch: true };
      } else {
        matchingControl.setErrors(null);
        return null;
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
      password: this.registerForm.value.password,
    };

    this.authService.postUser(userData).subscribe({
      next: (response) => {
        this.userService.saveUserId(response.userId);

        const authBody = {
          email: this.registerForm.value.email,
          password: this.registerForm.value.password,
        };

        this.authService.authenticate(authBody).subscribe({
          next: (authResponse) => {
            const token = authResponse.jwtToken;
            this.jwtService.saveToken(token);

            this.router.navigate(['/home']).then(() => {
              this.errorService.showError('Registrácia prebehla úspešne.');
            });
          },
          error: (_) => {
            this.router.navigate(['/404']);
          },
        });
      },
      error: (error: HttpErrorResponse) => {
        this.isError = true;
        switch (error.status) {
          case 409:
            this.errorText = 'Používateľ už existuje.';
            break;
          case 404:
            this.errorText = error.error;
            break;
          default:
            this.errorText = 'Neznáma chyba.';
            break;
        }
      },
    });
  }

  hideError() {
    this.isError = false;
  }

  redirectToLogin() {
    this.router.navigate(['/login']);
  }
}
