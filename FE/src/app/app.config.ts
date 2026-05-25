import {
  ApplicationConfig,
  provideAppInitializer,
  inject,
} from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app.routes';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { authInterceptor } from '@interceptors/auth.interceptor';
import { httpErrorInterceptor } from '@interceptors/http-error.interceptor';
import { ConfigService } from '@services/config.service';
import { firstValueFrom } from 'rxjs';
import { KeycloakService } from '@services/keycloak.service';
import { KeycloakService as AngularKeycloakService } from 'keycloak-angular';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideAnimationsAsync(),
    AngularKeycloakService,
    provideAppInitializer(() => {
      const configService = inject(ConfigService);
      const keycloakService = inject(KeycloakService);

      return firstValueFrom(configService.loadConfig())
        .then(() => keycloakService.initialize())
        .catch((error) => {
          console.error('Config or Keycloak initialization failed:', error);
          return null;
        });
    }),
    provideHttpClient(withInterceptors([authInterceptor, httpErrorInterceptor])),
  ],
};
