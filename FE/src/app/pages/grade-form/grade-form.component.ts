import { Component, OnInit, signal } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import {
  MatStep,
  MatStepContent,
  MatStepLabel,
  MatStepper,
  MatStepperNext,
  MatStepperPrevious,
  StepperOrientation,
} from '@angular/material/stepper';
import { MatCheckbox } from '@angular/material/checkbox';
import { MatButton } from '@angular/material/button';
import { MatError, MatFormField, MatLabel } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import {
  AsyncPipe,
  KeyValuePipe,
  NgClass,
  NgForOf,
  NgIf,
  NgSwitch,
  NgSwitchCase,
} from '@angular/common';
import { MatSlider, MatSliderThumb } from '@angular/material/slider';
import { FormService } from '@services/form.service';
import { MatRadioButton, MatRadioGroup } from '@angular/material/radio';
import { MatList, MatListItem } from '@angular/material/list';
import { MatOption, MatSelect } from '@angular/material/select';
import { Router } from '@angular/router';
import { NotificationService } from '@services/notification.service';
import { USER_FORM_ID } from '@pages/home/home.component';
import { BaseChartDirective } from 'ng2-charts';
import { catchError, map, Observable, of } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { StepperSelectionEvent } from '@angular/cdk/stepper';
import { Answer, AnsweredForm, Form, Option } from '../../types';
import { SubjectService } from '@services/subject.service';
import { BreakpointObserver } from '@angular/cdk/layout';
import { FormQuestionComponent } from '@components/form-question/form-question.component';
import { BasicInformationStepComponent } from '@components/grade-form-steps/basic-information-step/basic-information-step.component';
import { MandatorySubjectsStepComponent } from '@components/grade-form-steps/mandatory-subjects-step/mandatory-subjects-step.component';
import { FocusStepComponent } from '@components/grade-form-steps/focus-step/focus-step.component';
import { HobbyStepComponent } from '@components/grade-form-steps/hobby-step/hobby-step.component';
import { QuestionTypes } from '@pages/grade-form/grade-form-types';

@Component({
  selector: 'app-grade-form',
  standalone: true,
  imports: [
    MatStep,
    ReactiveFormsModule,
    MatStepLabel,
    MatCheckbox,
    MatButton,
    MatStepperPrevious,
    MatLabel,
    MatFormField,
    MatInput,
    MatStepperNext,
    MatStepper,
    KeyValuePipe,
    MatSlider,
    NgForOf,
    MatSliderThumb,
    NgSwitch,
    NgSwitchCase,
    MatRadioGroup,
    MatRadioButton,
    NgIf,
    MatList,
    MatListItem,
    MatError,
    MatSelect,
    MatOption,
    BaseChartDirective,
    NgClass,
    AsyncPipe,
    FormQuestionComponent,
    BasicInformationStepComponent,
    MandatorySubjectsStepComponent,
    MatStepContent,
    FocusStepComponent,
    HobbyStepComponent,
  ],
  templateUrl: './grade-form.component.html',
  styleUrl: './grade-form.component.scss',
})
export class GradeFormComponent implements OnInit {
  form!: Form;
  formGroups: FormGroup[] = [];
  existingAnswers: AnsweredForm | null = null;
  loading = true;
  stepperOrientation: Observable<StepperOrientation>;
  activeStep = signal(0);

  constructor(
    private fb: FormBuilder,
    private formService: FormService,
    private router: Router,
    private errorService: NotificationService,
    private subjectService: SubjectService,
    private breakpointObserver: BreakpointObserver,
  ) {
    this.stepperOrientation = this.breakpointObserver
      .observe('(min-width: 768px)')
      .pipe(map(({ matches }) => (matches ? 'horizontal' : 'vertical')));
  }

  ngOnInit(): void {
    // First, check if the user has already submitted the form
    this.formService
      .getForm(USER_FORM_ID)
      .pipe(
        switchMap((formData) => {
          this.form = formData;
          // Check for existing submission
          return this.formService.getExistingFormAnswers(USER_FORM_ID).pipe(
            catchError(() => {
              // Handle error when no existing answers are found
              return of(null);
            }),
          );
        }),
      )
      .subscribe({
        next: (answers) => {
          this.existingAnswers = answers;
          this.createFormGroups();
          this.loading = false;
        },
        error: (error) => {
          this.loading = false;
          console.error('Error loading form data:', error);
        },
      });
  }

  onStepChange(event: StepperSelectionEvent) {
    console.log(this.formGroups)
    const selectedIndex = event.selectedIndex;
    this.activeStep.set(selectedIndex);
  }

  createFormGroups() {
    this.formGroups = this.form.sections.map((section) => {
      const group: { [key: string]: any } = {};

      section.questions.forEach((question) => {
        // Default values
        let defaultValue = question.answerType === QuestionTypes.NUMERIC ? 0 : '';

        // If existing answers exist, find the corresponding answer
        if (this.existingAnswers) {
          const existingSection = this.existingAnswers.sections.find(
            (s) => s.sectionTitle === section.sectionTitle,
          );

          if (existingSection) {
            const existingQuestion = existingSection.questions.find(
              (q) => q.id === question.id,
            );

            if (existingQuestion) {
              if (question.answerType === QuestionTypes.CHECKBOX && question.options) {
                // Handle checkbox answers
                question.options.forEach((option, index) => {
                  const isChecked = existingQuestion.answers.some((answer) =>
                    answer.texts.some(
                      (answer) => answer.textOfAnswer === option.questionOption,
                    ),
                  );
                  group[question.questionIdentifier + index.toString()] = [isChecked];
                });
                return; // Skip setting default value for checkbox
              } else {
                // For other answer types, use the first text answer
                defaultValue =
                  existingQuestion.answers[0]?.texts[0].textOfAnswer ||
                  defaultValue;
              }
            }
          }
        }

        // Set up form control
        if (question.answerType === 'CHECKBOX' && question.options) {
          question.options.forEach((option, index) => {
            group[question.questionIdentifier + index.toString()] = [false];
          });
        } else if (question.answerType === 'NUMERIC') {
          group[question.questionIdentifier] = [
            defaultValue,
            question.optional ? [] : Validators.required,
          ];
        } else {
          group[question.questionIdentifier] = [
            defaultValue,
            question.optional ? [] : Validators.required,
          ];
        }
      });

      return this.fb.group(group);
    });
  }

  onSubmit() {
    let allValid = true;
    console.log(this.formGroups)
    this.formGroups.forEach((group) => {
      Object.keys(group.controls).forEach((key) => {
        group.controls[key].markAsTouched();
        if (group.controls[key].invalid) {
          allValid = false;
        }
      });
    });

    if (!allValid) {
      console.error('Form is invalid');
      return;
    }

    const answers: Answer[] = [];
    this.formGroups.forEach((group, index) => {
      const section = this.form.sections[index];
      section.questions.forEach((question) => {
        const answer: Answer = {
          questionId: question.id,
          texts: [],
        };
        if (question.answerType === QuestionTypes.CHECKBOX) {
          question.options.forEach((option: Option, index) => {
            if (group.get(`${question.questionIdentifier}${index}`)?.value) {
              answer.texts.push({ textOfAnswer: option.questionOption });
            }
          });
        } else {
          answer.texts.push({
            textOfAnswer: group.get(question.questionIdentifier)?.value,
          });
        }
        answers.push(answer);
      });
    });

    const result = {
      formId: this.form.id,
      answers: answers,
    };

    this.formService.submitFormAnswer(result).subscribe({
      next: () => {
        this.router.navigate(['/home']).then(() => {
          this.errorService.showSuccess(
            'Vyplnenie dotazníka prebehlo úspešne.',
          );
        });
      },
      error: () => {
        this.router.navigate(['/home']).then(() => {
          this.errorService.showError('Pri vyplnení dotazníka nastala chyba.');
        });
      },
    });
  }
}
