import {computed, inject, Injectable, signal} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable, tap} from "rxjs";
import { AppConfig } from '../types';

@Injectable({providedIn: 'root'})
export class ConfigService {
  private readonly config = signal<AppConfig | undefined>(undefined);

  private readonly http = inject(HttpClient);
  readonly apiUrl = computed(() => this.config()?.API_URL);
  readonly environment = computed(() => this.config()?.ENVIRONMENT);

  loadConfig(): Observable<AppConfig> {
    return this.http.get<AppConfig>('/assets/config/config.json')
      .pipe(
        tap(config => {
          this.config.set(config);
        })
      );
  }
}

