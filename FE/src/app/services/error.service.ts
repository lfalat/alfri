import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';

@Injectable({
  providedIn: 'root'
})
export class ErrorService {
  constructor(private snackBar: MatSnackBar) { }

  public showError(message: string, action: string = 'X', duration: number = 50000): void {
    this.snackBar.open(message, action, {
      duration: duration,
      panelClass: ['error-snackbar'],
      verticalPosition: 'top',
      horizontalPosition: 'end'
    });
  }
}
