import {
  AfterViewInit,
  Component,
  computed,
  inject,
  OnInit,
  signal,
  TemplateRef,
  ViewChild,
} from '@angular/core';
import { AdminService } from '@services/admin.service';
import { UserStore } from '../../stores/user.store';

import { FormsModule } from '@angular/forms';
import { PasswordPair, RegisterUserDto, Role, UserDto } from '../../types';
import { MatMenu, MatMenuItem, MatMenuTrigger } from '@angular/material/menu';
import { MatButton, MatIconButton } from '@angular/material/button';
import { MatIcon } from '@angular/material/icon';
import { MatDialog } from '@angular/material/dialog';
import { PasswordChangeModalComponent } from '@components/password-change-modal/password-change-modal.component';
import { ChangeSubjectsModalComponent } from '@components/change-subjects-modal/change-subjects-modal.component';
import { AuthRole } from '@enums/auth-role';
import { NotificationService } from '@services/notification.service';
import { CreateUserModalComponent } from '@components/create-user-modal/create-user-modal.component';
import {
  GenericTableComponent,
  TableCellContext,
  TableConfig,
  TextCellRendererComponent,
} from '@components/generic-table';
import { GenericTableUtils } from '@components/generic-table/generic-table.utils';
import { AuthService } from '@services/auth.service';

type UserTableRow = UserDto & { id: number };

@Component({
  selector: 'app-admin',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.scss'],
  imports: [
    FormsModule,
    MatMenu,
    MatMenuItem,
    MatIconButton,
    MatMenuTrigger,
    MatIcon,
    MatButton,
    GenericTableComponent,
  ],
  standalone: true,
})
export class AdminPageComponent implements OnInit, AfterViewInit {
  @ViewChild('rolesCell') rolesCellTemplate!: TemplateRef<TableCellContext<UserTableRow>>;
  @ViewChild('optionsCell') optionsCellTemplate!: TemplateRef<TableCellContext<UserTableRow>>;

  users = signal<UserDto[]>([]);
  availableRoles: Role[] = [];
  tableConfig = signal<TableConfig<UserTableRow> | null>(null);

  protected readonly AuthRole = AuthRole;
  private readonly adminService = inject(AdminService);
  private readonly userStore = inject(UserStore);
  private readonly dialog = inject(MatDialog);
  private readonly notificationService = inject(NotificationService);
  private readonly authService = inject(AuthService);

  usersPage = computed(() => {
    const mapped = this.users().map((u) => ({ ...u, id: u.userId }));
    return GenericTableUtils.pageOf(mapped);
  });

  ngOnInit(): void {
    this.fetchData();
  }

  ngAfterViewInit(): void {
    this.tableConfig.set({
      columns: [
        {
          id: 'firstName',
          header: 'Meno',
          field: 'firstName',
          cellRenderer: TextCellRendererComponent,
        },
        {
          id: 'lastName',
          header: 'Priezvisko',
          field: 'lastName',
          cellRenderer: TextCellRendererComponent,
        },
        {
          id: 'email',
          header: 'Email',
          field: 'email',
          cellRenderer: TextCellRendererComponent,
        },
        {
          id: 'roles',
          header: 'Rola',
          cellRenderer: TextCellRendererComponent,
          cellTemplate: this.rolesCellTemplate,
        },
        {
          id: 'options',
          header: 'Možnosti',
          cellRenderer: TextCellRendererComponent,
          cellTemplate: this.optionsCellTemplate,
          align: 'right',
        },
      ],
      serverSide: false,
      enablePagination: false,
      showEmptyState: true,
      emptyMessage: 'Žiadni používatelia',
      minHeight: '200px',
    });
  }

  fetchData(): void {
    this.adminService.getAllUsers().subscribe((data) => {
      this.users.set(data);
      if (data.length > 0) {
        this.tableConfig.update((config) => {
          if (!config) {
            return config;
          }

          return {
            ...config,
            showEmptyState: false,
          };
        });
      }
    });
    this.userStore.getRoles().subscribe((roles) => {
      this.availableRoles = roles;
    });
  }

  userHasRole(user: UserDto, role: Role): boolean {
    return user.roles.some((userRole: Role) => userRole.id === role.id);
  }

  onRoleToggle(user: UserDto, role: Role, event: Event): void {
    const isAdd = (event.target as HTMLInputElement).checked;
    this.adminService.updateUserRole(user.userId, role, isAdd).subscribe({
      next: () => {
        if (isAdd) {
          user.roles.push(role);
        } else {
          user.roles = user.roles.filter((userRole: Role) => userRole.id !== role.id);
        }
        this.notificationService.showSuccess('Údaje úspešne zmenené.');
      },
      error: () => {
        this.notificationService.showError('Neočakávaná chyba systému.');
      },
    });
  }

  deleteUser(userId: number): void {
    if (confirm('Are you sure you want to delete this user?')) {
      this.adminService.deleteUser(userId).subscribe({
        next: () => {
          this.users.update((users) => users.filter((user) => user.userId !== userId));
          this.notificationService.showSuccess('Údaje úspešne zmenené.');
        },
        error: () => {
          this.notificationService.showError('Neočakávaná chyba systému.');
        },
      });
    }
  }

  openSubjectModal(userId: number): void {
    const selectedUser = this.users().find(
      (user) => user.userId === userId && this.userHasRole(user, { id: 2, name: 'teacher' }),
    );

    if (!selectedUser) {
      return;
    }

    const dialogRef = this.dialog.open(ChangeSubjectsModalComponent, {
      data: { userId, user: selectedUser },
      width: '600px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result) {
        this.notificationService.showSuccess('Údaje úspešne zmenené.');
      }
    });
  }

  openChangePasswordModal(user: UserDto) {
    const dialogRef = this.dialog.open(PasswordChangeModalComponent, {
      width: '400px',
      disableClose: false,
      data: { user },
    });

    dialogRef.afterClosed().subscribe((result: PasswordPair) => {
      if (result) {
        this.adminService.resetUserPassword(user.userId, result.newPassword).subscribe({
          next: () => {
            this.notificationService.showSuccess('Údaje úspešne zmenené.');
          },
          error: () => {
            this.notificationService.showError('Neočakávaná chyba systému.');
          },
        });
      }
    });
  }

  openUserFormDialog(): void {
    const dialogRef = this.dialog.open(CreateUserModalComponent, {
      width: '400px',
      disableClose: false,
    });

    dialogRef.afterClosed().subscribe((result: RegisterUserDto) => {
      if (result) {
        this.authService.postUser(result).subscribe({
          next: () => {
            this.notificationService.showSuccess('Používateľ bol úspešne vytvorený');
          },
          error: () => {
            this.notificationService.showError('Neočakávaná chyba systému.');
          },
        });
      }
    });
  }

  isUserTeacher(user: UserDto): boolean {
    return user.roles.some((userRole) => userRole.name === 'teacher');
  }
}
