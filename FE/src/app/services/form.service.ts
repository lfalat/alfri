import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AnsweredForm, Form, Question, UserFormAnswers } from '../types';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class FormService {
  private readonly http = inject(HttpClient);
  private readonly config = inject(ConfigService);
  private readonly URL = `${this.config.apiUrl()}/form`;

  getForm(formId: number): Observable<Form> {
    return this.http.get<Form>(`${this.URL}/get-form/${formId}`);
  }

  submitFormAnswer(userFormAnswers: UserFormAnswers) {
    // TODO extract as a constant
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.post(
      `${this.URL}/submit-form`,
      userFormAnswers,
      httpOptions,
    );
  }

  changeFormAnswer(userFormAnswers: UserFormAnswers) {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.post(
      `${this.URL}/replace-form`,
      userFormAnswers,
      httpOptions,
    );
  }

  hasUserFilledForm(formId: number): Observable<void> {
    return this.http.get<void>(`${this.URL}/has-filled-form/${formId}`);
  }

  getExistingFormAnswers(formId: number): Observable<AnsweredForm> {
    return this.http.get<AnsweredForm>(
      `${this.URL}/get-user-answers/${formId}`,
    );
  }

  getMandatorySubjectsByStudyProgramIdAndYear(
    studyProgram: number,
    year: number,
  ) {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.get<Question[]>(
      `${this.URL}/get-mandatory-subjects/${studyProgram}/${year - 1}`,
      httpOptions,
    );
  }
}
