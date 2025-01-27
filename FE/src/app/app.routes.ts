import type { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
import { RegistrationComponent } from './registration/registration.component';
import { AuthGuards, roleAppGuard, tokenAppGuard } from './auth-guards';
import { ErrorPageComponent } from './error-page/error-page.component';
import { ProfileComponent } from './profile/profile.component';
import { inject } from '@angular/core';
import { SubjectsComponent } from './subjects/subjects.component';
import { RecommendationComponent } from './recommendation/recommendation.component';
import { GradeFormComponent } from './grade-form/grade-form.component';
import { SubjectDetailComponent } from './subject-detail/subject-detail.component';
import { SubjectsChanceComponent } from './subjects-chance/subjects-chance.component';
import { SubjectsClusteringComponent } from './subjects-clustering/subjects-clustering.component';
import { SubjectReportsComponent } from './subject-reports/subject-reports.component';
import { SubjectGradeCorrelationComponent } from './subject-grade-correlation/subject-grade-correlation.component';
import { AdminPageComponent } from './admin-page/admin-page.component';
import { PassingPredictionComponent } from './passing-prediction/passing-prediction.component';
import { AuthRole } from './types';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  {
    path: 'home',
    component: HomeComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegistrationComponent },
  {
    path: 'subjects',
    component: SubjectsComponent,
    canActivate: [() => inject(AuthGuards).canActivate()],
  },
  {
    path: 'subjects',
    component: SubjectsComponent,
    canActivate: [() => inject(AuthGuards).canActivate()]
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
    canActivate: [() => inject(AuthGuards).canActivate()]
  },
  {
    path: 'subject-reports',
    component: SubjectReportsComponent,
    canActivate: [() => inject(AuthGuards).canActivate()]
  },
  {
    path: 'subjects-grades-correlation',
    component: SubjectGradeCorrelationComponent,
    canActivate: [() => inject(AuthGuards).canActivate()]
  },
  {
    path: 'admin-page',
    component: AdminPageComponent,
    canActivate: [tokenAppGuard, roleAppGuard],
    data: {role: AuthRole.ADMIN}
  },
  {
    path: 'keywords',
    component: KeywordsComponent,
    canActivate: [() => inject(AuthGuards).canActivate()]
  },
  { path: 'profile', component: ProfileComponent },
  { path: '404', component: ErrorPageComponent },
  { path: 'grade-form', component: GradeFormComponent },
  { path: '**', redirectTo: 'login' }
];
