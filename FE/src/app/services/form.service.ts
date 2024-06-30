import { Injectable } from '@angular/core';
import { environment } from '../../environments/environments-prod';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { JwtService } from './jwt.service';
import { Observable } from 'rxjs';
import { Form, UserFormAnswers } from '../types';

@Injectable({
  providedIn: 'root'
})
export class FormService {
  private readonly URL = `${environment.API_URL}/form`;

  constructor(private http: HttpClient, private jwtService: JwtService) {
  }

  getForm(formId: number): Observable<Form> {
    return this.http.get<Form>(`${this.URL}/get-form/${formId}`);
  }

  submitFormAnswer(userFormAnswers: UserFormAnswers) {
    // TODO extract as a constant
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    };

    return this.http.post(`${this.URL}/submit-form`, userFormAnswers, httpOptions);
  }

  changeFormAnswer(userFormAnswers: UserFormAnswers) {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    };

    return this.http.post(`${this.URL}/replace-form`, userFormAnswers, httpOptions);
  }

  hasUserFilledForm(formId: number): Observable<void> {
    return this.http.get<void>(`${this.URL}/has-filled-form/${formId}`);
  }
}
