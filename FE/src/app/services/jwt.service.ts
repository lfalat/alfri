import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class JwtService {

  constructor() { }

  saveToken(token: string) {
    localStorage.setItem('access_token', token);
  }
}
