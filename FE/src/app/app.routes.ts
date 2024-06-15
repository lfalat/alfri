import type { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
import { RegistrationComponent } from './registration/registration.component';
import { AuthGuard } from './auth-guard';
import { ErrorPageComponent } from './error-page/error-page.component';
import { ProfileComponent } from './profile/profile.component';
import { inject } from '@angular/core';
import { SubjectsComponent } from './subjects/subjects.component';
import { RecommendationComponent } from './recommendation/recommendation.component';
import { GradeFormComponent } from './grade-form/grade-form.component';
import { SubjectDetailComponent } from './subject-detail/subject-detail.component';
import { SubjectsChanceComponent } from './subjects-chance/subjects-chance.component';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  {
    path: 'home',
    component: HomeComponent,
    canActivate: [() => inject(AuthGuard).canActivate()],
  },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegistrationComponent },
  {
    path: 'subjects',
    component: SubjectsComponent,
    canActivate: [() => inject(AuthGuard).canActivate()],
  },
  {
    path: 'subjects',
    component: SubjectsComponent,
    canActivate: [() => inject(AuthGuard).canActivate()]
  },
  {
    path: 'subjects/:subjectCode',
    component: SubjectDetailComponent,
    canActivate: [() => inject(AuthGuard).canActivate()],
  },
  {
    path: 'subjects-chance',
    component: SubjectsChanceComponent,
    canActivate: [() => inject(AuthGuard).canActivate()],
  },
  {
    path: 'recommendation',
    component: RecommendationComponent,
    canActivate: [() => inject(AuthGuard).canActivate()],
  },
  { path: 'profile', component: ProfileComponent },
  { path: '404', component: ErrorPageComponent },
  { path: 'grade-form', component: GradeFormComponent },
  { path: '**', redirectTo: 'login' }
];
