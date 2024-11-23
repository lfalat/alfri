import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';

@Injectable({
  providedIn: 'root'
})
export class NotificationService {
  constructor(private snackBar: MatSnackBar) {
  }

  public showError(message: string, action: string = 'X', duration: number = 6000): void {
    this.snackBar.open(message, action, {
      duration: duration,
      panelClass: ['error-snackbar'],
      horizontalPosition: 'right',
      verticalPosition: 'top'
    });
  }

  public showSuccess(message: string, action: string = 'X', duration: number = 6000): void {
    this.snackBar.open(message, action, {
      duration: duration,
      panelClass: ['success-snackbar'],
      horizontalPosition: 'right',
      verticalPosition: 'top'
    });
  }

  public showWarning(message: string, action: string = 'X', duration: number = 6000): void {
    this.snackBar.open(message, action, {
      duration: duration,
      panelClass: ['warning-snackbar'],
      horizontalPosition: 'right',
      verticalPosition: 'top'
    });
  }
}
