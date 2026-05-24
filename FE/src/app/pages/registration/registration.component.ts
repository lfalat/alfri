import { Component, inject, OnDestroy } from '@angular/core';
import {
  AbstractControl,
  AbstractControlOptions,
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  ValidationErrors,
  ValidatorFn,
  Validators,
} from '@angular/forms';
import { Router } from '@angular/router';

import { HttpErrorResponse } from '@angular/common/http';
import { AuthService } from '@services/auth.service';
import { NotificationService } from '@services/notification.service';
import { UserStore } from '../../stores/user.store';
import { JwtService } from '@services/jwt.service';
import { ReplaySubject } from 'rxjs';
import { RegisterUserDto, Role } from '../../types';
import { MatButton } from '@angular/material/button';
import { NgOptimizedImage } from '@angular/common';

@Component({
  selector: 'app-registration-form',
  standalone: true,
  imports: [ReactiveFormsModule, MatButton, NgOptimizedImage],
  templateUrl: './registration.component.html',
  styleUrl: './registration.component.scss',
})
export class RegistrationComponent implements OnDestroy {
  registerForm: FormGroup;
  roles: Role[] = [];
  showPassword = false;
  showConfirmPassword = false;
  readonly destroyed$: ReplaySubject<void> = new ReplaySubject(1);
  private readonly formBuilder = inject(FormBuilder);
  private readonly router = inject(Router);
  private readonly authService = inject(AuthService);
  private readonly errorService = inject(NotificationService);
  private readonly userStore = inject(UserStore);
  private readonly jwtService = inject(JwtService);
  private readonly notificationService = inject(NotificationService);

  constructor() {
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
          [Validators.required, Validators.pattern(/^(?=.*[A-Z])(?=.*\d)(?=.*[a-z]).{8,}$/)],
        ],
        confirmPassword: ['', [Validators.required]],
      },
      formOptions,
    );
  }

  ngOnDestroy() {
    this.destroyed$.next();
    this.destroyed$.complete();
  }

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }

  toggleConfirmPasswordVisibility() {
    this.showConfirmPassword = !this.showConfirmPassword;
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

      if (control.value === matchingControl.value) {
        matchingControl.setErrors(null);
        return null;
      }

      matchingControl.setErrors({ mustMatch: true });
      return { mustMatch: true };
    };
  }

  onSubmit() {
    if (this.registerForm.invalid) {
      return;
    }

    const userData: RegisterUserDto = {
      firstName: this.registerForm.value.name,
      lastName: this.registerForm.value.surname,
      email: this.registerForm.value.email,
      password: this.registerForm.value.password,
    };

    this.authService.postUser(userData).subscribe({
      next: (response) => {
        this.userStore.saveUserId(response.userId);

        const authBody = {
          email: this.registerForm.value.email,
          password: this.registerForm.value.password,
        };

        this.authService.authenticate(authBody).subscribe({
          next: (authResponse) => {
            const token = authResponse.jwtToken;
            this.jwtService.saveToken(token);

            this.router.navigate(['/home']).then(() => {
              this.errorService.showSuccess('Registrácia prebehla úspešne.');
            });
          },
          error: () => {
            this.router.navigate(['/404']);
          },
        });
      },
      error: (error: HttpErrorResponse) => {
        switch (error.status) {
          case 409:
            this.notificationService.showError('Používateľ už existuje.');
            break;
          case 404:
            this.notificationService.showError(error.error);
            break;
          default:
            this.notificationService.showError('Neznáma chyba. Kontaktujte prosím administrátora.');
            break;
        }
      },
    });
  }

  redirectToLogin() {
    this.router.navigate(['/login']);
  }
}
