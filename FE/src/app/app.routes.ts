import type { Routes } from '@angular/router';
import { HomeComponent } from '@pages/home/home.component';
import { LoginComponent } from '@pages/login/login.component';
import { RegistrationComponent } from '@pages/registration/registration.component';
import {
  AuthGuards,
  loggedOutOnlyGuard,
  roleAppGuard,
  tokenAppGuard,
} from './auth-guards';
import { ErrorPageComponent } from '@pages/error-page/error-page.component';
import { ProfileComponent } from '@pages/profile/profile.component';
import { inject } from '@angular/core';
import { SubjectsComponent } from '@pages/subjects/subjects.component';
import { RecommendationComponent } from '@pages/recommendation/recommendation.component';
import { GradeFormComponent } from '@pages/grade-form/grade-form.component';
import { SubjectDetailComponent } from '@pages/subject-detail/subject-detail.component';
import { SubjectsChanceComponent } from '@pages/subjects-chance/subjects-chance.component';
import { SubjectsClusteringComponent } from '@pages/subjects-clustering/subjects-clustering.component';
import { SubjectReportsComponent } from '@pages/subject-reports/subject-reports.component';
import { SubjectGradeCorrelationComponent } from '@pages/subject-grade-correlation/subject-grade-correlation.component';
import { AdminPageComponent } from '@pages/admin-page/admin-page.component';
import { PassingPredictionComponent } from '@pages/passing-prediction/passing-prediction.component';
import { KeywordsComponent } from '@pages/keywords/keywords.component';
import { AuthRole } from '@enums/auth-role';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  {
    path: 'home',
    component: HomeComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  {
    path: 'login',
    component: LoginComponent,
    canActivate: [loggedOutOnlyGuard],
  },
  {
    path: 'register',
    component: RegistrationComponent,
    canActivate: [loggedOutOnlyGuard],
  },
  {
    path: 'subjects',
    component: SubjectsComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  {
    path: 'subjects',
    component: SubjectsComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  {
    path: 'subjects/:subjectCode',
    component: SubjectDetailComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  {
    path: 'subjects-chance',
    component: SubjectsChanceComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  {
    path: 'passing-prediction',
    component: PassingPredictionComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  {
    path: 'recommendation',
    component: RecommendationComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  {
    path: 'clustering',
    component: SubjectsClusteringComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  {
    path: 'subject-reports',
    component: SubjectReportsComponent,
    canActivate: [() => inject(AuthGuards).canActivate(), roleAppGuard],
    data: { role: [AuthRole.ADMIN, AuthRole.TEACHER, AuthRole.VEDENIE] },
  },
  {
    path: 'subjects-grades-correlation',
    component: SubjectGradeCorrelationComponent,
    canActivate: [() => inject(AuthGuards).canActivate(), roleAppGuard],
    data: { role: [AuthRole.ADMIN, AuthRole.TEACHER, AuthRole.VEDENIE] },
  },
  {
    path: 'admin-page',
    component: AdminPageComponent,
    canActivate: [tokenAppGuard, roleAppGuard],
    data: { role: AuthRole.ADMIN },
  },
  {
    path: 'keywords',
    component: KeywordsComponent,
    canActivate: [() => inject(AuthGuards).canActivate(), roleAppGuard],
    data: { role: [AuthRole.ADMIN, AuthRole.TEACHER, AuthRole.VEDENIE] },
  },
  {
    path: 'profile',
    component: ProfileComponent,
    canActivate: [tokenAppGuard],
  },
  {
    path: 'grade-form',
    component: GradeFormComponent,
    canActivate: [tokenAppGuard],
  },
  { path: '404', component: ErrorPageComponent },
  { path: '**', redirectTo: 'login' },
];
