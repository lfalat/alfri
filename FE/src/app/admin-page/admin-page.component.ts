import { Component, OnInit } from '@angular/core';
import { AdminService } from '../services/admin.service';
import { UserService } from '../services/user.service';
import { Role, UserDto } from '../types';
import { NgForOf } from '@angular/common';

@Component({
  selector: 'app-admin',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.scss'],
  imports: [
    NgForOf
  ],
  standalone: true
})
export class AdminPageComponent implements OnInit {
  users: UserDto[] = [];
  availableRoles: Role[] = [];

  constructor(private as: AdminService, private us: UserService) {}

  ngOnInit(): void {
    this.fetchData();
  }

  fetchData(): void {
    this.as.getAllUsers().subscribe((data) => {
      this.users = data;
    });
    this.us.getRoles().subscribe((roles) => {
      this.availableRoles = roles;
    });
  }

  userHasRole(user: any, role: Role): boolean {
    return user.roles.some((userRole: Role) => userRole.id === role.id);
  }

  onRoleToggle(user: any, role: Role, event: Event): void {
    const isChecked = (event.target as HTMLInputElement).checked;
    if (isChecked) {
      this.as.addUserRole(user.id, role).subscribe(() => {
        user.roles.push(role);
      });
    } else {
      this.as.removeUserRole(user.id, role).subscribe(() => {
        user.roles = user.roles.filter((userRole: Role) => userRole.id !== role.id);
      });
    }
  }

  deleteUser(userId: number): void {
    if (confirm('Are you sure you want to delete this user?')) {
      this.as.deleteUser(userId).subscribe(() => {
        this.users = this.users.filter((user) => user.userId !== userId);
      });
    }
  }
}
