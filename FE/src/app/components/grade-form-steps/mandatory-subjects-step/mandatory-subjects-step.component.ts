import { Component, effect, Input, signal, Signal } from '@angular/core';
import { AnsweredForm, Form, Question, Section } from '../../../types';
import {
  FormControl,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import {
  MatStepLabel,
  MatStepperNext,
  MatStepperPrevious,
} from '@angular/material/stepper';
import { MatButton } from '@angular/material/button';
import { FormQuestionComponent } from '@components/form-question/form-question.component';
import { NgForOf, NgIf } from '@angular/common';
import { MatProgressSpinner } from '@angular/material/progress-spinner';
import { FormService } from '@services/form.service';

@Component({
  selector: 'app-mandatory-subjects-step',
  standalone: true,
  imports: [
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
  @Input() formAnswers: AnsweredForm | null = null;

  constructor(private formService: FormService) {
    effect(
      () => {
        if (this.activeStep() === 1) {
          if (!this.selectedYear || !this.selectedStudyProgram) {
            if (!this.formAnswers) {
              this.selectedStudyProgram =
                this.basicInformationFormGroup.get('question_odbor')?.value;
              this.selectedYear =
                this.basicInformationFormGroup.get('question_rocnik')?.value;
              this.loadMandatorySubjects();
            } else {
              this.form.sections[1].questions =
                this.formAnswers.sections[1].questions;
              this.selectedStudyProgram =
                this.formAnswers.sections[0].questions.find(
                  (question) => question.questionTitle === 'Odbor',
                )?.answers[0].texts[0].textOfAnswer;
              this.selectedYear = this.formAnswers.sections[0].questions.find(
                (question) => question.questionTitle === 'Ročník v škole',
              )?.answers[0].texts[0].textOfAnswer;
              this.initFormGroup();
            }
          }

          this.isLoading.set(true);

          if (this.formAnswers) {
            if (
              this.selectedStudyProgram ===
                this.formAnswers.sections[0].questions.find(
                  (question) => question.questionTitle === 'Odbor',
                )?.answers[0].texts[0].textOfAnswer &&
              this.selectedYear ===
                this.formAnswers.sections[0].questions.find(
                  (question) => question.questionTitle === 'Ročník v škole',
                )?.answers[0].texts[0].textOfAnswer
            ) {
              this.initFormGroup();
            }
          }
          // When the study program or year are different from the previously selected ones load new data from BE
          if (this.yearOrStudyProgramAreDifferent()) {
            console.log('different');
            this.loadMandatorySubjects();
            return;
          }

          this.initFormGroup();
        }
      },
      { allowSignalWrites: true },
    );
  }

  private loadMandatorySubjects() {
    const studyProgram =
      this.basicInformationFormGroup.get('question_odbor')?.value;
    const year = this.basicInformationFormGroup.get('question_rocnik')?.value;

    this.selectedStudyProgram = studyProgram;
    this.selectedYear = year;

    this.formService
      .getMandatorySubjectsByStudyProgramIdAndYear(studyProgram, year)
      .subscribe({
        next: (data) => {
          this.questions.set(data);

          console.log('remove');
          Object.keys(this.formGroup.controls).forEach((key) => {
            this.formGroup.removeControl(key);
          });

          data.forEach((question) => {
            this.formGroup.addControl(
              question.questionIdentifier,
              new FormControl('', question.optional ? [] : Validators.required),
            );
          });
          this.form.sections[1].questions = data;
          this.isLoading.set(false);
        },
        error: (error) => {
          console.error(error);
          this.isLoading.set(false);
        },
      });
  }

  private initFormGroup() {
    if (!this.formAnswers) {
      this.questions.set(this.form.sections[1].questions);
      this.isLoading.set(false);
      return;
    }

    const group: Record<string, any[]> = {};

    this.formAnswers.sections[1].questions.forEach((question) => {
      group[question.questionIdentifier] = [
        question.answers[0]?.texts[0]?.textOfAnswer || '',
        question.optional ? [] : Validators.required,
      ];
    });

    console.log('remove');
    Object.keys(this.formGroup.controls).forEach((key) => {
      this.formGroup.removeControl(key);
    });

    Object.keys(group).forEach((key) => {
      this.formGroup.addControl(
        key,
        new FormControl(group[key][0], group[key][1]),
      );
    });

    console.log(this.formGroup);

    this.questions.set(this.formAnswers.sections[1].questions);
    this.isLoading.set(false);
  }

  private yearOrStudyProgramAreDifferent(): boolean {
    const filledStudyProgram =
      this.basicInformationFormGroup.get('question_odbor')?.value;
    const filledYear =
      this.basicInformationFormGroup.get('question_rocnik')?.value;
    console.log(
      filledYear,
      this.selectedYear,
      filledStudyProgram,
      this.selectedStudyProgram,
    );

    return (
      filledYear !== this.selectedYear ||
      filledStudyProgram !== this.selectedStudyProgram
    );
  }
}
