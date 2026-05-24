import { Component, inject } from '@angular/core';
import { AuthService } from '@services/auth.service';
import { MatButton } from '@angular/material/button';
import { NgOptimizedImage } from '@angular/common';

@Component({
  selector: 'app-login-form',
  standalone: true,
  imports: [MatButton, NgOptimizedImage],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss',
})
export class LoginComponent {
  private readonly authService = inject(AuthService);

  onSubmit() {
    this.authService.logIn();
  }

  redirectToRegistration() {
    this.authService.registerWithKeycloak();
  }
}
