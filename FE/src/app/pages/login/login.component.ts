import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { AuthService } from '@services/auth.service';
import { JwtService } from '@services/jwt.service';
import { Router } from '@angular/router';
import { LoginUserDto } from '../../types';
import { NotificationService } from '@services/notification.service';
import { MatButton } from '@angular/material/button';
import { UserService } from '@services/user.service';
import { NgOptimizedImage } from '@angular/common';

@Component({
  selector: 'app-login-form',
  standalone: true,
  imports: [ReactiveFormsModule, MatButton, NgOptimizedImage],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss',
})
export class LoginComponent {
  loginForm: FormGroup;
  showPassword = false;
  private readonly formBuilder = inject(FormBuilder);
  private readonly authService = inject(AuthService);
  private readonly jwtService = inject(JwtService);
  private readonly router = inject(Router);
  private readonly notificationService = inject(NotificationService);
  private readonly userService = inject(UserService);

  constructor() {
    this.loginForm = this.formBuilder.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required]],
    });
  }

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
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

        this.userService.loadUserData();

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
