import { Component, effect, Input, signal, Signal } from '@angular/core';
import { Form, Question, Section } from '../../../types';
import {
  FormControl,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
} from '@angular/forms';
import {
  MatStepContent,
  MatStepLabel,
  MatStepperNext,
  MatStepperPrevious,
} from '@angular/material/stepper';
import { MatButton } from '@angular/material/button';
import { FormQuestionComponent } from '@components/form-question/form-question.component';
import { NgForOf, NgIf } from '@angular/common';
import { QuestionTypes } from '@pages/grade-form/grade-form-types';
import { MatProgressSpinner } from '@angular/material/progress-spinner';
import { FormService } from '@services/form.service';

@Component({
  selector: 'app-mandatory-subjects-step',
  standalone: true,
  imports: [
    MatStepContent,
    MatButton,
    MatStepperNext,
    MatStepperPrevious,
    FormQuestionComponent,
    NgForOf,
    MatStepLabel,
    FormsModule,
    ReactiveFormsModule,
    MatProgressSpinner,
    NgIf,
  ],
  templateUrl: './mandatory-subjects-step.component.html',
  styleUrl: './mandatory-subjects-step.component.scss',
})
export class MandatorySubjectsStepComponent {
  @Input() section!: Section;
  @Input() formGroup!: FormGroup;
  @Input() basicInformationFormGroup!: FormGroup;
  @Input() shouldFetchData!: boolean;
  @Input() activeStep!: Signal<number>;
  questions = signal<Question[]>([]);
  isLoading = signal(false);
  selectedYear: string | undefined;
  selectedStudyProgram: string | undefined;
  @Input() form!: Form;

  constructor(private formService: FormService) {
    effect(
      () => {
        if (this.activeStep() === 1) {
          this.loadMandatorySubjects();
        }
      },
      { allowSignalWrites: true },
    );
  }

  private loadMandatorySubjects() {
    // if (!this.shouldFetchData) {
    //   console.log(this.formGroup)
    //   return;
    // }

    const studyProgram =
      this.basicInformationFormGroup.get('question_odbor')?.value;
    const year = this.basicInformationFormGroup.get('question_rocnik')?.value;

    if (
      this.selectedYear === year &&
      this.selectedStudyProgram === studyProgram
    ) {
      return;
    } else if (!this.selectedYear && !this.selectedStudyProgram) {
      this.selectedStudyProgram = studyProgram;
      this.selectedYear = year;
    }

    this.isLoading.set(true);

    this.formService
      .getMandatorySubjectsByStudyProgramIdAndYear(studyProgram, year)
      .subscribe({
        next: (data) => {
          this.questions.set(data);

          data.forEach((question) => {
            this.formGroup.addControl(
              question.questionIdentifier,
              new FormControl(''),
            );
          });
          this.form.sections[1].questions = data;
          this.isLoading.set(false);
        },
        error: (error) => {
          console.error('Error loading mandatory subjects:', error);
          this.isLoading.set(false);
        },
      });
  }

  mapSectionValues() {
    console.log( this.formGroup.value);
  }
}
