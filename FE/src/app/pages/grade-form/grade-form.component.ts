import { Component, ElementRef, OnInit, signal, ViewChild } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import {
  MatStep, MatStepContent,
  MatStepLabel,
  MatStepper,
  MatStepperNext,
  MatStepperPrevious, StepperOrientation,
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
import { GradeFormUtil } from './grade-form-util';
import { BaseChartDirective } from 'ng2-charts';
import {
  BarController,
  BarElement,
  CategoryScale,
  Chart,
  Chart as chartJs,
  ChartDataset,
  Filler,
  Legend,
  LinearScale,
  LineElement,
  PointElement,
  RadarController,
  RadialLinearScale,
  TimeScale,
  Title,
  Tooltip,
} from 'chart.js';
import { catchError, map, Observable, of } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { StepperSelectionEvent } from '@angular/cdk/stepper';
import { Answer, AnsweredForm, Form, Option } from '../../types';
import { GradeFormSection, QuestionTypes } from '@pages/grade-form/grade-form-types';
import { SubjectService } from '@services/subject.service';
import { BreakpointObserver } from '@angular/cdk/layout';
import { FormQuestionComponent } from '@components/form-question/form-question.component';
import {
  BasicInformationStepComponent
} from '@components/grade-form-steps/basic-information-step/basic-information-step.component';
import {
  MandatorySubjectsStepComponent
} from '@components/grade-form-steps/mandatory-subjects-step/mandatory-subjects-step.component';

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
  ],
  templateUrl: './grade-form.component.html',
  styleUrl: './grade-form.component.scss',
})
export class GradeFormComponent implements OnInit {
  form!: Form;
  formGroups: FormGroup[] = [];
  @ViewChild('radarChart') chart!: ElementRef<HTMLCanvasElement>;
  radarChart: Chart | undefined;
  readonly GradeFormUtil = GradeFormUtil;
  readonly QuestionTypes = QuestionTypes;
  existingAnswers: AnsweredForm | null = null;
  loading = true;
  stepperOrientation: Observable<StepperOrientation>;
  activeStep = signal(0);

  private colors = [
    'rgba(255, 99, 132, 0.8)',
    'rgba(54, 162, 235, 0.8)',
    'rgba(255, 206, 86, 0.8)',
    'rgba(75, 192, 192, 0.8)',
    'rgba(153, 102, 255, 0.8)',
    'rgba(255, 159, 64, 0.8)',
    'rgba(128, 128, 128, 0.8)',
    'rgba(255, 0, 255, 0.8)',
    'rgba(0, 255, 255, 0.8)',
    'rgba(0, 128, 0, 0.8)',
    'rgba(128, 0, 128, 0.8)',
    'rgba(0, 0, 255, 0.8)',
  ];

  chartDatasets: ChartDataset[] = [
    {
      data: [],
    },
  ];

  constructor(
    private fb: FormBuilder,
    private formService: FormService,
    private router: Router,
    private errorService: NotificationService,
    private subjectService: SubjectService,
    private breakpointObserver: BreakpointObserver,
  ) {
    chartJs.register(
      CategoryScale,
      LinearScale,
      PointElement,
      LineElement,
      TimeScale,
      Title,
      Tooltip,
      Legend,
      RadialLinearScale,
      RadarController,
      Filler,
      BarController,
      BarElement,
    );

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
          console.log(this.formGroups[0])
          this.loading = false;
        },
        error: (error) => {
          this.loading = false;
          console.error('Error loading form data:', error);
        },
      });
  }

  onStepChange(event: StepperSelectionEvent) {
    const selectedIndex = event.selectedIndex;
    console.log(selectedIndex);
    this.activeStep.set(selectedIndex);
  }

  createFormGroups() {
    this.formGroups = this.form.sections.map((section) => {
      const group: { [key: string]: any } = {};

      section.questions.forEach((question) => {
        // Default values
        let defaultValue = question.answerType === 'NUMERIC' ? 0 : '';

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
              if (question.answerType === 'CHECKBOX' && question.options) {
                // Handle checkbox answers
                question.options.forEach((option, index) => {
                  const isChecked = existingQuestion.answers.some((answer) =>
                    answer.texts.some(
                      (answer) => answer.textOfAnswer === option.questionOption,
                    ),
                  );
                  group[question.questionIdentifier + index.toString()] = [
                    isChecked,
                  ];
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
    this.formGroups.forEach((group) => {
      Object.keys(group.controls).forEach((key) => {
        group.controls[key].markAsTouched();
        if (group.controls[key].invalid) {
          allValid = false;
        }
      });
    });

    if (allValid) {
      // Handle form submission
      const answers: Answer[] = [];
      this.formGroups.forEach((group, index) => {
        const section = this.form.sections[index];
        section.questions.forEach((question) => {
          const answer: Answer = {
            questionId: question.id,
            texts: [],
          };
          if (question.answerType === 'CHECKBOX') {
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
          this.errorService.showError('Pri vyplnení dotazníka nastala chyba.');
        },
      });
    }
  }

  nextSection($event: StepperSelectionEvent) {
    switch ($event.selectedIndex) {
      case GradeFormSection.AREAS_OF_INTEREST:
        if (!this.radarChart) {
          this.initializeRadarChart($event.selectedIndex);
        }
        break;
      case GradeFormSection.MANDATORY_SUBJECT_GRADES:
        this.loadMandatorySubjects();
        break;
    }
  }

  initializeRadarChart(index: number): void {
    const canvas = this.chart.nativeElement;
    const value = canvas.getContext('2d');

    if (value) {
      const focusLabelMapping: { [key: string]: string } = {
        question_matematika_focus: 'Matematika',
        question_logika_focus: 'Logika',
        question_programovanie_focus: 'Programovanie',
        question_dizajn_focus: 'Dizajn',
        question_ekonomika_focus: 'Ekonomika',
        question_manazment_focus: 'Manažment',
        question_hardver_focus: 'Hardvér',
        question_siete_focus: 'Sieťové technológie',
        question_data_focus: 'Práca s dátami',
        question_testovanie_focus: 'Testovanie',
        question_jazyky_focus: 'Jazyky',
        question_fyzicka_aktivita_focus: 'Fyzické zameranie',
      };

      this.radarChart = new Chart(value, {
        type: 'radar',
        data: {
          labels: Object.values(focusLabelMapping),
          datasets: this.chartDatasets,
        },
        options: {
          responsive: false,
          scales: {
            r: {
              angleLines: {
                display: true,
              },
              suggestedMin: 0,
              suggestedMax: 10,
            },
          },
          plugins: {
            tooltip: {
              callbacks: {
                label: (context) => {
                  const label = context.label || '';
                  const value = context.raw || 0;
                  return `${label}: ${value}`;
                },
              },
            },
            legend: {
              display: false,
            },
          },
        },
      });

      this.chartDatasets[0] = {
        label: 'Focus predmetu',
        fill: true,
        backgroundColor: this.colors,
        borderColor: this.colors,
        borderWidth: 1,
        data: [],
      };

      this.chartDatasets[0].data = Object.values(
        Object.fromEntries(
          Object.keys(focusLabelMapping).map((key) => [
            key,
            this.formGroups[index].value[key],
          ]),
        ),
      ) as number[];

      this.radarChart.update();

      this.formGroups[index].valueChanges.pipe().subscribe((data) => {
        const sortedData = Object.fromEntries(
          Object.keys(focusLabelMapping).map((key) => [key, data[key]]),
        );

        this.chartDatasets[0].data = Object.values(sortedData) as number[];
        this.radarChart?.update();
      });
    }
  }

  private loadMandatorySubjects() {
    const studyProgram =
      this.formGroups[GradeFormSection.BASIC_INFORMATION].get(
        'question_odbor',
      )?.value;
    const year =
      this.formGroups[GradeFormSection.BASIC_INFORMATION].get(
        'question_rocnik',
      )?.value;
    this.subjectService
      .getMandatorySubjectsByStudyProgramIdAndYear(0, 100, studyProgram, year)
      .subscribe({
        next: (data) => {
          console.log(data);
          this.form.sections[
            GradeFormSection.MANDATORY_SUBJECT_GRADES
          ].questions = data.content.map((subject) => ({
            id: 0,
            questionTitle: subject.name,
            answerType: 'GRADE',
            optional: false,
            questionIdentifier: `subject_${subject.code}`,
            positionInQuestionnaire: 0,
            options: [],
          }));
        },
        error: (error) => {
          console.error('Error loading mandatory subjects:', error);
        },
      });
  }

  test() {
    console.log(this.formGroups[0])
  }
}
