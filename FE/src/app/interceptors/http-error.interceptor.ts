import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { catchError } from 'rxjs';
import { inject } from '@angular/core';
import { NotificationService } from '@services/notification.service';
import { JwtService } from '@services/jwt.service';
import { Router } from '@angular/router';

export const httpErrorInterceptor: HttpInterceptorFn = (req, next) => {
  const notificationService = inject(NotificationService);
  const jwtService = inject(JwtService);
  const router = inject(Router);

  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      // Handle 401 Unauthorized - token is invalid or expired
      if (error.status === 401) {
        // Clear the invalid token
        jwtService.removeToken();

        // Redirect to login page
        router.navigate(['/login']);
      }

      if (error.status === 403) {
        notificationService.showError('Na vykonanie akcie nemáte oprávnenie', '');
      }

      if (error.status === 418) {
        notificationService.showWarning('Nevyplnili ste dotazník', 'OK');
      }
      throw error;
    }),
  );
};
