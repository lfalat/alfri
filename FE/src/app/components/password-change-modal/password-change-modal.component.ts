import { Component, Inject } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import {
  MAT_DIALOG_DATA,
  MatDialogActions,
  MatDialogRef,
  MatDialogTitle,
} from '@angular/material/dialog';
import { MatFormField, MatLabel } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { MatButton } from '@angular/material/button';
import { UserDto } from '../../types';

@Component({
  selector: 'app-password-change-modal',
  standalone: true,
  imports: [
    MatDialogTitle,
    ReactiveFormsModule,
    MatFormField,
    MatInput,
    MatDialogActions,
    MatButton,
    MatLabel,
  ],
  templateUrl: './password-change-modal.component.html',
  styleUrl: './password-change-modal.component.scss',
})
export class PasswordChangeModalComponent {
  passwordForm: FormGroup;

  constructor(
    private fb: FormBuilder,
    private dialogRef: MatDialogRef<PasswordChangeModalComponent>,
    @Inject(MAT_DIALOG_DATA) public data: { user: UserDto },
  ) {
    this.passwordForm = this.fb.group({
      oldPassword: ['', Validators.required],
      newPassword: ['', [Validators.required, Validators.minLength(6)]],
      confirmPassword: ['', Validators.required],
    });
  }

  submit() {
    if (this.passwordForm.valid) {
      const { oldPassword, newPassword, confirmPassword } =
        this.passwordForm.value;
      if (newPassword !== confirmPassword) {
        alert('New password and confirmation do not match!');
        return;
      }

      const passwordChangeData = {
        oldPassword: oldPassword,
        newPassword: newPassword,
      };

      this.dialogRef.close(passwordChangeData);
    }
  }

  close() {
    this.dialogRef.close();
  }
}
