import type { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { LoginFormComponent } from './components/login-form/login-form.component';
import { RegistrationFormComponent } from './components/registration-form/registration-form.component';
import { AuthGuard } from './auth-guard';

export const routes: Routes = [
  { path: 'home', component: HomeComponent, canActivate: [AuthGuard] },
  { path: 'login', component: LoginFormComponent },
  { path: 'register', component: RegistrationFormComponent },
];
