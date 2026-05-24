import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { catchError } from 'rxjs';
import { inject } from '@angular/core';
import { NotificationService } from '@services/notification.service';
import { Router } from '@angular/router';
import { KeycloakService } from '@services/keycloak.service';

export const httpErrorInterceptor: HttpInterceptorFn = (req, next) => {
  const notificationService = inject(NotificationService);
  const router = inject(Router);
  const keycloakService = inject(KeycloakService);

  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 401 && !req.headers.has('Authorization')) {
        keycloakService.login(router.url);
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
