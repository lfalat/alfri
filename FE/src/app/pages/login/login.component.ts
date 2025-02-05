import { Component } from '@angular/core';
import { MatButton } from '@angular/material/button';
import { MatCard } from '@angular/material/card';
import { MatError, MatFormField, MatLabel } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { MatOption } from '@angular/material/autocomplete';
import { MatSelect } from '@angular/material/select';
import { NgForOf, NgIf } from '@angular/common';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { AuthService } from '@services/auth.service';
import { JwtService } from '@services/jwt.service';
import { Router } from '@angular/router';
import { LoginUserDto } from '../../types';
import { NotificationService } from '@services/notification.service';

@Component({
  selector: 'app-login-form',
  standalone: true,
  imports: [
    MatButton,
    MatCard,
    MatError,
    MatFormField,
    MatInput,
    MatLabel,
    MatOption,
    MatSelect,
    NgForOf,
    NgIf,
    ReactiveFormsModule,
  ],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss',
})
export class LoginComponent {
  loginForm: FormGroup;

  constructor(
    private formBuilder: FormBuilder,
    private authService: AuthService,
    private jwtService: JwtService,
    private router: Router,
    private notificationService: NotificationService
  ) {
    this.loginForm = this.formBuilder.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required]],
    });
  }

  onSubmit() {
    if (this.loginForm.invalid) {
      return;
    }

    const userData: LoginUserDto = {
      email: this.loginForm.value.email,
      password: this.loginForm.value.password,
    };

    this.authService.authenticate(userData).subscribe({
      next: (authResponse) => {
        const token = authResponse.jwtToken;
        this.jwtService.saveToken(token);

        this.router.navigate(['/home']);
      },
      error: (error) => {
        switch (error.status) {
          case 409:
            this.notificationService.showError('Používateľ už existuje.');
            break;
          case 401:
            this.notificationService.showError('Boli zadané nesprávne údaje.');
            break;
          default:
            this.notificationService.showError('Neznáma chyba. Kontaktujte prosím administrátora.');
            break;
        }
      },
    });
  }

  redirectToRegistration() {
    this.router.navigate(['/register']);
  }
}
