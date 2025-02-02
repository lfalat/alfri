import { Component } from '@angular/core';
import { AuthRole } from '@enums/auth-role';
import { NgIf, NgSwitchCase } from '@angular/common';
import { UserHomeComponent } from './user-home/user-home.component';
import { TeacherHomeComponent } from './teacher-home/teacher-home.component';
import { HasRoleDirective } from '@directives/auth.directive';
import { NotificationService } from '@services/notification.service';
export const USER_FORM_ID = 69;

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    NgIf,
    NgSwitchCase,
    UserHomeComponent,
    TeacherHomeComponent,
    HasRoleDirective,
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss',
})
export class HomeComponent {
  protected readonly AuthRole = AuthRole;

  constructor() {
  }
}
