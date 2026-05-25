import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { ConfigService } from '@services/config.service';
import { KeycloakService } from '@services/keycloak.service';
import { from, switchMap } from 'rxjs';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const configService = inject(ConfigService);
  const keycloakService = inject(KeycloakService);
  const apiUrl = configService.apiUrl();

  if (!apiUrl || !req.url.startsWith(apiUrl)) {
    return next(req);
  }

  return from(keycloakService.getToken()).pipe(
    switchMap((token) => {
      if (!token) {
        return next(req);
      }

      return next(
        req.clone({
          setHeaders: {
            Authorization: `Bearer ${token}`,
          },
        }),
      );
    }),
  );
};
