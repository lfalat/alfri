import { Component } from '@angular/core';
import { AuthRole } from '@enums/auth-role';

import { UserHomeComponent } from './user-home/user-home.component';
import { TeacherHomeComponent } from './teacher-home/teacher-home.component';
import { HasRoleDirective } from '@directives/auth.directive';
import { VedenieHomeComponent } from '@pages/home/vedenie-home/vedenie-home.component';
import { AdminPageComponent } from '@pages/admin-page/admin-page.component';
export const USER_FORM_ID = 69;

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    UserHomeComponent,
    TeacherHomeComponent,
    HasRoleDirective,
    VedenieHomeComponent,
    AdminPageComponent,
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss',
})
export class HomeComponent {
  protected readonly AuthRole = AuthRole;

  constructor() {}
}
