import type { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
import { RegistrationComponent } from './registration/registration.component';
import { AuthGuard } from './auth-guard';
import { ErrorPageComponent } from './error-page/error-page.component';
import { inject } from '@angular/core';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'home', component: HomeComponent, canActivate: [() => inject(AuthGuard).canActivate()] },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegistrationComponent },
  { path: '404', component: ErrorPageComponent },
  { path: '**', redirectTo: 'login' }
];
