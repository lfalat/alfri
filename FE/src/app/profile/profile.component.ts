import { Component } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { ChangePasswordDto, UserDto } from '../types';
import { UserService } from '../services/user.service';
import { Subject, takeUntil } from 'rxjs';
import { NgIf } from '@angular/common';
import { AuthService } from '../services/auth.service';
import { MatFormField, MatLabel } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { MatButton } from '@angular/material/button';

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
    MatButton
  ],
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent {
  public profileForm: FormGroup;

  private readonly destroy: Subject<void> = new Subject<void>();
  private _userData: UserDto | undefined;
  isLoading = true;

  constructor(private fb: FormBuilder, private us: UserService, private as: AuthService) {
    this.profileForm = this.fb.group({
      currentPassword: ['', Validators.required],
      newPassword: ['', Validators.required],
      confirmNewPassword: ['', Validators.required]
    }, {
      validator: this.mustMatch('newPassword', 'confirmNewPassword')
    });
    this.us.getUserInfo().subscribe(
      value => {
        this._userData = value;
        this.isLoading = false;
      },
      takeUntil(this.destroy));
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
        newPassword: this.profileForm.value.newPassword
      };
      this.as.changePassword(passwordData).subscribe();
      this.profileForm.reset();

    } else {

    }
  }

  get userData(): UserDto {
    return <UserDto>this._userData;
  }

}
