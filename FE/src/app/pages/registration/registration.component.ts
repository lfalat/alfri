import { Component, OnDestroy } from '@angular/core';
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
import { MatCard } from '@angular/material/card';
import { MatError, MatFormField, MatLabel } from '@angular/material/form-field';
import { MatButton } from '@angular/material/button';
import { MatInput } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { NgForOf, NgIf } from '@angular/common';
import { HttpClientModule, HttpErrorResponse } from '@angular/common/http';
import { AuthService } from '@services/auth.service';
import { NotificationService } from '@services/notification.service';
import { UserService } from '@services/user.service';
import { JwtService } from '@services/jwt.service';
import { ReplaySubject } from 'rxjs';
import { RegisterUserDto, Role } from '../../types';

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
export class RegistrationComponent implements OnDestroy {
  registerForm: FormGroup;
  roles: Role[] = [];
  readonly destroyed$: ReplaySubject<void> = new ReplaySubject(1);

  constructor(
    private formBuilder: FormBuilder,
    private router: Router,
    private authService: AuthService,
    private errorService: NotificationService,
    private userService: UserService,
    private jwtService: JwtService,
    private notificationService: NotificationService
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
      },
      formOptions,
    );
  }

  ngOnDestroy() {
    this.destroyed$.next();
    this.destroyed$.complete();
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
