import { ApplicationConfig, importProvidersFrom, provideAppInitializer, inject } from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app.routes';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import {
  provideHttpClient,
  withInterceptors,
  withInterceptorsFromDi,
} from '@angular/common/http';
import { JwtModule } from '@auth0/angular-jwt';
import { tokenGetter } from '@interceptors/auth.interceptor';
import { httpErrorInterceptor } from '@interceptors/http-error.interceptor';
import { ConfigService } from '@services/config.service';
import { firstValueFrom } from 'rxjs';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideAnimationsAsync(),
    provideAppInitializer(() => {
      const configService = inject(ConfigService);
      return firstValueFrom(configService.loadConfig());
    }),
    importProvidersFrom(
      JwtModule.forRoot({
        config: {
          tokenGetter: tokenGetter,
          allowedDomains: [
            'localhost:8080',
            'alfri-backend.happystone-577431b5.norwayeast.azurecontainerapps.io'
          ],
          disallowedRoutes: [
            'http://localhost:8080/register',
            'http://localhost:8080/authenticate',
            'https://alfri-backend.happystone-577431b5.norwayeast.azurecontainerapps.io/api/auth/register',
            'https://alfri-backend.happystone-577431b5.norwayeast.azurecontainerapps.io/api/auth/authenticate',
          ],
          skipWhenExpired: false,
        },
      }),
    ),
    provideHttpClient(
      withInterceptorsFromDi(),
      withInterceptors([httpErrorInterceptor]),
    ),
  ],
};
