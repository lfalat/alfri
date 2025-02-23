import { Component, OnInit } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { UserService } from '@services/user.service';
import { NgIf } from '@angular/common';
import { AuthService } from '@services/auth.service';
import { MatFormField, MatLabel } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { MatButton } from '@angular/material/button';
import { NotificationService } from '@services/notification.service';
import { Router } from '@angular/router';
import { UserFormResultsComponent } from '@components/user-form-results/user-form-results.component';
import { USER_FORM_ID } from '@pages/home/home.component';
import { FormService } from '@services/form.service';
import { HasRoleDirective } from '@directives/auth.directive';
import { AnsweredForm, ChangePasswordDto } from '../../types';
import { AuthRole } from '@enums/auth-role';

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
    UserFormResultsComponent,
    HasRoleDirective,
  ],
  styleUrls: ['./profile.component.scss'],
})
export class ProfileComponent implements OnInit {
  protected readonly AuthRole = AuthRole;
  formData: AnsweredForm | undefined;
  profileForm: FormGroup;

  constructor(
    private readonly formBuilder: FormBuilder,
    readonly userService: UserService,
    private readonly authService: AuthService,
    private readonly notificationService: NotificationService,
    private readonly router: Router,
    private readonly formService: FormService,
  ) {
    this.profileForm = this.formBuilder.group({
      currentPassword: ['', Validators.required],
      newPassword: ['', Validators.required],
      confirmNewPassword: ['', Validators.required],
    });
  }

  ngOnInit() {
    if (this.authService.hasRole([AuthRole.STUDENT])) {
      this.formService.getExistingFormAnswers(USER_FORM_ID).subscribe({
        next: (data: AnsweredForm) => {
          this.formData = data;
        },
        error: () => {},
      });
    }
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
        email: this.userService.userData.email,
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

  redirectToUserForm() {
    this.router.navigate(['/grade-form']);
  }
}
