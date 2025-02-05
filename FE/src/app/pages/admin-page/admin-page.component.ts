import { Component, OnInit } from '@angular/core';
import { AdminService } from '@services/admin.service';
import { UserService } from '@services/user.service';
import { NgForOf, NgIf } from '@angular/common';
import { FormsModule } from '@angular/forms';
import {
  ChangePasswordDto, PasswordPair,
  Role,
  UserDto,
} from '../../types';
import { MatMenu, MatMenuItem, MatMenuTrigger } from '@angular/material/menu';
import { MatIconButton } from '@angular/material/button';
import { MatIcon } from '@angular/material/icon';
import { MatDialog } from '@angular/material/dialog';
import { PasswordChangeModalComponent } from '@components/password-change-modal/password-change-modal.component';
import { ChangeSubjectsModalComponent } from '@components/change-subjects-modal/change-subjects-modal.component';
import { AuthRole } from '@enums/auth-role';
import { HasRoleDirective } from '@directives/auth.directive';
import { NotificationService } from '@services/notification.service';
import { AuthService } from '@services/auth.service';

@Component({
  selector: 'app-admin',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.scss'],
  imports: [NgForOf, NgIf, FormsModule, MatMenu, MatMenuItem, MatIconButton, MatMenuTrigger, MatIcon, HasRoleDirective],
  standalone: true,
})
export class AdminPageComponent implements OnInit {
  users: UserDto[] = [];
  availableRoles: Role[] = [];
  protected readonly AuthRole = AuthRole;

  constructor(
    private as: AdminService,
    private us: UserService,
    private dialog: MatDialog,
    private notificationService: NotificationService,
    private authService: AuthService
  ) {}

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

  userHasRole(user: UserDto, role: Role): boolean {
    return user.roles.some((userRole: Role) => userRole.id === role.id);
  }

  onRoleToggle(user: UserDto, role: Role, event: Event): void {
    const isAdd = (event.target as HTMLInputElement).checked;
    this.as.updateUserRole(user.userId, role, isAdd).subscribe({
      next: () => {
        if (isAdd) {
          user.roles.push(role);
        } else {
          user.roles = user.roles.filter(
            (userRole: Role) => userRole.id !== role.id,
          );
        }
        this.notificationService.showSuccess('Údaje úspešne zmenené.');
      },
      error: () => {
        this.notificationService.showError('Neočakávaná chyba systému.');
      }
    });
  }

  deleteUser(userId: number): void {
    if (confirm('Are you sure you want to delete this user?')) {
      this.as.deleteUser(userId).subscribe({
        next: () => {
          this.users = this.users.filter((user) => user.userId !== userId);
          this.notificationService.showSuccess('Údaje úspešne zmenené.');
        }, error: () => {
          this.notificationService.showError('Neočakávaná chyba systému.');
        }
      });
    }
  }

  openSubjectModal(userId: number): void {
    const selectedUser = this.users.find(
      (user) =>
        user.userId === userId &&
        this.userHasRole(user, { id: 2, name: 'teacher' })
    );

    if (!selectedUser) {
      return;
    }

    const dialogRef = this.dialog.open(ChangeSubjectsModalComponent, {
      data: { userId, user: selectedUser },
      width: '600px',
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.notificationService.showSuccess('Údaje úspešne zmenené.');
      }
    });
  }

  openChangePasswordModal(user: UserDto) {
    const dialogRef = this.dialog.open(PasswordChangeModalComponent, {
      width: '400px',
      disableClose: false
    });

    dialogRef.afterClosed().subscribe((result: PasswordPair) => {
      if (result) {
        const passwordChange: ChangePasswordDto = {
          email: user.email,
          oldPassword: result.oldPassword,
          newPassword: result.newPassword
        }

        this.authService.changePassword(passwordChange).subscribe({
          next: () => {
            this.notificationService.showSuccess('Údaje úspešne zmenené.');
          },
          error: () => {
            this.notificationService.showError('Neočakávaná chyba systému.');
          }
        })
      }
    });
  }

  isUserTeacher(user: UserDto): boolean {
    // TODO BE is returning wrong format of roles, change it
    return user.roles.some(userRole => userRole.name === 'teacher')
  }
}
