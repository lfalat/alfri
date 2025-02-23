import { Injectable } from '@angular/core';
import { MatSnackBar, MatSnackBarConfig } from '@angular/material/snack-bar';

@Injectable({
  providedIn: 'root',
})
export class NotificationService {
  constructor(private readonly snackBar: MatSnackBar) {}

  public showError(
    message: string,
    action: string = 'X',
    duration: number = 6000,
  ): void {
    const config: MatSnackBarConfig = {
      duration,
      panelClass: ['error-snackbar'],
      horizontalPosition: 'end',
      verticalPosition: 'top',
    };

    this.snackBar.open(message, action, config);
  }

  public showSuccess(
    message: string,
    action: string = 'X',
    duration: number = 6000,
  ): void {
    const config: MatSnackBarConfig = {
      duration,
      panelClass: ['success-snackbar'],
      horizontalPosition: 'end',
      verticalPosition: 'top',
    };

    this.snackBar.open(message, action, config);
  }

  public showWarning(
    message: string,
    action: string = 'X',
    duration: number = 6000000,
  ): void {
    const config: MatSnackBarConfig = {
      duration,
      panelClass: ['warning-snackbar'],
      horizontalPosition: 'end',
      verticalPosition: 'top',
    };

    this.snackBar.open(message, action, config);
  }

  public hideSnackbar(): void {
    this.snackBar.dismiss();
  }
}
