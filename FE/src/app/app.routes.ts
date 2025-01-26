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
import { SubjectsClusteringComponent } from './subjects-clustering/subjects-clustering.component';
import { SubjectReportsComponent } from './subject-reports/subject-reports.component';
import { SubjectGradeCorrelationComponent } from './subject-grade-correlation/subject-grade-correlation.component';
import { AdminPageComponent } from './admin-page/admin-page.component';
import { PassingPredictionComponent } from './passing-prediction/passing-prediction.component';
import { KeywordsComponent } from './keywords/keywords.component';

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
    path: 'passing-prediction',
    component: PassingPredictionComponent,
    canActivate: [() => inject(AuthGuard).canActivate()],
  },
  {
    path: 'recommendation',
    component: RecommendationComponent,
    canActivate: [() => inject(AuthGuard).canActivate()],
  },
  {
    path: 'clustering',
    component: SubjectsClusteringComponent,
    canActivate: [() => inject(AuthGuard).canActivate()]
  },
  {
    path: 'subject-reports',
    component: SubjectReportsComponent,
    canActivate: [() => inject(AuthGuard).canActivate()]
  },
  {
    path: 'subjects-grades-correlation',
    component: SubjectGradeCorrelationComponent,
    canActivate: [() => inject(AuthGuard).canActivate()]
  },
  {
    path: 'admin-page',
    component: AdminPageComponent,
    canActivate: [() => inject(AuthGuard).canActivate()]
  },
  {
    path: 'keywords',
    component: KeywordsComponent,
    canActivate: [() => inject(AuthGuard).canActivate()]
  },
  { path: 'profile', component: ProfileComponent },
  { path: '404', component: ErrorPageComponent },
  { path: 'grade-form', component: GradeFormComponent },
  { path: '**', redirectTo: 'login' }
];
