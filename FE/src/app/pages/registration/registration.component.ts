import { Component, inject } from '@angular/core';
import { AuthService } from '@services/auth.service';
import { MatButton } from '@angular/material/button';
import { NgOptimizedImage } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-registration-form',
  standalone: true,
  imports: [MatButton, NgOptimizedImage],
  templateUrl: './registration.component.html',
  styleUrl: './registration.component.scss',
})
export class RegistrationComponent {
  private readonly authService = inject(AuthService);
  private readonly router = inject(Router);

  onSubmit() {
    this.authService.registerWithKeycloak();
  }

  redirectToLogin() {
    this.router.navigate(['/login']);
  }
}
