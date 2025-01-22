import { Component, OnInit } from '@angular/core';
import { AuthRole, UserDto } from '../types';
import { UserService } from '../services/user.service';
import { NgIf, NgSwitchCase } from '@angular/common';
import { UserHomeComponent } from './user-home/user-home.component';
import { TeacherHomeComponent } from './teacher-home/teacher-home.component';
import { HasRoleDirective } from '../directives/auth.directive';
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
export class HomeComponent implements OnInit {
  user: UserDto | undefined;

  constructor(private userService: UserService) {}

  ngOnInit() {
  }

  protected readonly AuthRole = AuthRole;
}
