import type { Routes } from '@angular/router';
import { HomeComponent } from '@pages/home/home.component';
import { AuthGuards, roleAppGuard, tokenAppGuard } from './auth-guards';
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
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  {
    path: 'home',
    component: HomeComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url)],
  },
  {
    path: 'subjects',
    component: SubjectsComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url)],
  },
  {
    path: 'subjects',
    component: SubjectsComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url)],
  },
  {
    path: 'subjects/:subjectCode',
    component: SubjectDetailComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url)],
  },
  {
    path: 'subjects-chance',
    component: SubjectsChanceComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url)],
  },
  {
    path: 'passing-prediction',
    component: PassingPredictionComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url)],
  },
  {
    path: 'recommendation',
    component: RecommendationComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url)],
  },
  {
    path: 'clustering',
    component: SubjectsClusteringComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url)],
  },
  {
    path: 'subject-reports',
    component: SubjectReportsComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url), roleAppGuard],
    data: { role: [AuthRole.ADMIN, AuthRole.TEACHER, AuthRole.VEDENIE] },
  },
  {
    path: 'subjects-grades-correlation',
    component: SubjectGradeCorrelationComponent,
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url), roleAppGuard],
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
    canActivate: [(_route, state) => inject(AuthGuards).canActivate(state.url), roleAppGuard],
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
  { path: '**', redirectTo: '404' },
];
