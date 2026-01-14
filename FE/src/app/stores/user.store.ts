import { computed, inject } from '@angular/core';
import {
  patchState,
  signalStore,
  withComputed,
  withMethods,
  withState,
} from '@ngrx/signals';
import { rxMethod } from '@ngrx/signals/rxjs-interop';
import { HttpClient } from '@angular/common/http';
import { JwtHelperService } from '@auth0/angular-jwt';
import { pipe, switchMap, tap } from 'rxjs';
import { Role, UserDto, UserState } from '../types';
import { ConfigService } from '@services/config.service';

const initialState: UserState = {
  userData: undefined,
  userId: undefined,
  isLoading: false,
};

export const UserStore = signalStore(
  { providedIn: 'root' },
  withState(initialState),
  withComputed(() => {
    const jwtHelper = inject(JwtHelperService);

    return {
      loggedIn: computed(() => !jwtHelper.isTokenExpired()),
    };
  }),
  withMethods((store) => {
    const http = inject(HttpClient);
    const configService = inject(ConfigService);
    const BE_URL = `${configService.apiUrl()}/user`;

    return {
      loadUserData: rxMethod<void>(
        pipe(
          tap(() => patchState(store, { isLoading: true })),
          switchMap(() =>
            http.get<UserDto>(`${BE_URL}/profile`).pipe(
              tap({
                next: (userData: UserDto) =>
                  patchState(store, { userData, isLoading: false }),
                error: () =>
                  patchState(store, { userData: undefined, isLoading: false }),
              }),
            ),
          ),
        ),
      ),
      loadUserInfo: () => {
        return http.get<UserDto>(`${BE_URL}/profile`);
      },
      getRoles: () => {
        return http.get<Role[]>(`${BE_URL}/roles`);
      },
      saveUserId: (userId: number) => {
        patchState(store, { userId });
      },
      setUserData: (userData: UserDto | undefined) => {
        patchState(store, { userData });
      },
      clearUserData: () => {
        patchState(store, { userData: undefined, userId: undefined });
      },
    };
  }),
);
