import { Component, OnInit } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { AnsweredForm, AuthRole, ChangePasswordDto, UserDto } from '../types';
import { UserService } from '../services/user.service';
import { Subject, takeUntil } from 'rxjs';
import { NgForOf, NgIf } from '@angular/common';
import { AuthService } from '../services/auth.service';
import { MatFormField, MatLabel } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { MatButton } from '@angular/material/button';
import { NotificationService } from '../services/notification.service';
import { Router } from '@angular/router';
import { MatCard } from '@angular/material/card';
import {
  MatCell,
  MatCellDef,
  MatColumnDef,
  MatHeaderCell,
  MatHeaderCellDef,
  MatHeaderRow,
  MatHeaderRowDef,
  MatRow,
  MatRowDef,
  MatTable,
} from '@angular/material/table';
import { BaseChartDirective } from 'ng2-charts';
import { MatChip, MatChipSet } from '@angular/material/chips';
import { UserFormResultsComponent } from '../user-form-results/user-form-results.component';
import { USER_FORM_ID } from '../home/home.component';
import { FormService } from '../services/form.service';
import { HasRoleDirective } from '../directives/auth.directive';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    NgIf,
    MatLabel,
    MatFormField,
    MatInput,
    MatButton,
    MatCard,
    MatTable,
    MatColumnDef,
    MatHeaderCell,
    MatCell,
    MatHeaderRow,
    MatRow,
    MatRowDef,
    MatCellDef,
    MatHeaderRowDef,
    MatHeaderCellDef,
    BaseChartDirective,
    MatChipSet,
    MatChip,
    NgForOf,
    UserFormResultsComponent,
    HasRoleDirective,
  ],
  styleUrls: ['./profile.component.scss'],
})
export class ProfileComponent implements OnInit {
  private readonly destroy: Subject<void> = new Subject<void>();

  _userData: UserDto | undefined;
  formData: AnsweredForm | undefined;
  isLoading = true;
  profileForm: FormGroup;

  constructor(
    private formBuilder: FormBuilder,
    private userService: UserService,
    private authService: AuthService,
    private notificationService: NotificationService,
    private router: Router,
    private formService: FormService,
  ) {
    this.profileForm = this.formBuilder.group(
      {
        currentPassword: ['', Validators.required],
        newPassword: ['', Validators.required],
        confirmNewPassword: ['', Validators.required],
      },
      {
        validator: this.mustMatch('newPassword', 'confirmNewPassword'),
      },
    );
    this.userService
      .loadUserInfo()
      .pipe(takeUntil(this.destroy))
      .subscribe((value) => {
        this._userData = value;
        this.isLoading = false;
      });
  }

  ngOnInit() {
    this.formService.getExistingFormAnswers(USER_FORM_ID).subscribe({
      next: (data: AnsweredForm) => {
        this.formData = data;
      },
      error: () => {},
    });
  }

  mustMatch(controlName: string, matchingControlName: string) {
    return (formGroup: FormGroup) => {
      const control = formGroup.controls[controlName];
      const matchingControl = formGroup.controls[matchingControlName];

      if (matchingControl.errors && !matchingControl.errors['mustMatch']) {
        return;
      }

      if (control.value !== matchingControl.value) {
        matchingControl.setErrors({ mustMatch: true });
      } else {
        matchingControl.setErrors(null);
      }
    };
  }

  changePassword() {
    if (this.profileForm.valid) {
      const passwordData: ChangePasswordDto = {
        email: this.userData.email,
        oldPassword: this.profileForm.value.currentPassword,
        newPassword: this.profileForm.value.newPassword,
      };
      this.authService.changePassword(passwordData).subscribe();
      this.profileForm.reset();
      this.notificationService.showError(
        'Heslo bolo úspešne zmenené!',
        '',
        3000,
      );
      this.router.navigate(['/home']);
    }
  }

  get userData(): UserDto {
    return <UserDto>this._userData;
  }

  redirectToUserForm() {
    this.router.navigate(['/grade-form']);
  }

  protected readonly AuthRole = AuthRole;
}
