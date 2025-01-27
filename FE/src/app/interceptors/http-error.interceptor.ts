import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { catchError } from 'rxjs';
import { inject } from '@angular/core';
import { NotificationService } from '@services/notification.service';

export const httpErrorInterceptor: HttpInterceptorFn = (req, next) => {
  const notificationService = inject(NotificationService);

  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 403) {
        notificationService.showError(
          'Na vykonanie akcie nemáte oprávnenie',
          '',
        );
      }

      if (error.status === 418) {
        notificationService.showWarning('Nevyplnili ste dotazník', 'OK');
      }
      throw error;
    }),
  );
};
