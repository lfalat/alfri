import { inject, Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { FormService } from '@services/form.service';
import { AnsweredForm } from '../types';
import { USER_FORM_ID } from '@pages/home/home.component';

@Injectable({
  providedIn: 'root',
})
export class FormDataService {
  private readonly formDataSubject = new BehaviorSubject<AnsweredForm | undefined>(
    undefined,
  );
  formData$ = this.formDataSubject.asObservable();
  private readonly formService = inject(FormService);

  fetchFormData() {
    this.formService.getExistingFormAnswers(USER_FORM_ID).subscribe({
      next: (data: AnsweredForm) => {
        this.formDataSubject.next(data);
      },
      error: () => {
        this.formDataSubject.next(undefined);
      },
    });
  }

  getFormData() {
    return this.formDataSubject.getValue();
  }

  setFormData(data: AnsweredForm) {
    this.formDataSubject.next(data);
  }
}
