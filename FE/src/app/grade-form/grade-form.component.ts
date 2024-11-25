import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatStep, MatStepLabel, MatStepper, MatStepperNext, MatStepperPrevious } from '@angular/material/stepper';
import { MatCheckbox } from '@angular/material/checkbox';
import { MatButton } from '@angular/material/button';
import { MatError, MatFormField, MatLabel } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { KeyValuePipe, NgForOf, NgIf, NgSwitch, NgSwitchCase } from '@angular/common';
import { MatSlider, MatSliderThumb } from '@angular/material/slider';
import { Answer, Form, Option } from '../types';
import { FormService } from '../services/form.service';
import { MatRadioButton, MatRadioGroup } from '@angular/material/radio';
import { MatList, MatListItem } from '@angular/material/list';
import { MatOption, MatSelect } from '@angular/material/select';
import { Router } from '@angular/router';
import { NotificationService } from '../services/notification.service';
import { USER_FORM_ID } from '../home/home.component';

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
    MatOption
  ],
  templateUrl: './grade-form.component.html',
  styleUrl: './grade-form.component.scss'
})
export class GradeFormComponent implements OnInit {
  form!: Form;
  formGroups: FormGroup[] = [];

  constructor(private fb: FormBuilder,
              private formService: FormService,
              private router: Router,
              private errorService: NotificationService) {
  }

  ngOnInit(): void {
    // TODO change formId dynamically
    this.formService.getForm(USER_FORM_ID).subscribe(data => {
      this.form = data;
      this.createFormGroups();
    });
  }

  createFormGroups() {
    this.formGroups = this.form.sections.map(section => {
      const group: { [key: string]: any } = {};
      section.questions.forEach(question => {
        if (question.answerType === 'CHECKBOX' && question.options) {
          question.options.forEach((option, index) => {
            group[question.questionIdentifier + index.toString()] = [''];
          });
        } else if (question.answerType === 'NUMERIC') {
          group[question.questionIdentifier] = [0, question.optional ? [] : Validators.required];
        } else {
          group[question.questionIdentifier] = ['', question.optional ? [] : Validators.required];
        }
      });
      return this.fb.group(group);
    });
  }

  onSubmit() {
    let allValid = true;
    this.formGroups.forEach(group => {
      Object.keys(group.controls).forEach(key => {
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
            texts: []
          };
          if (question.answerType === 'CHECKBOX') {
            question.options.forEach((option: Option, index) => {
              if (group.get(`${question.questionIdentifier}${index}`)?.value) {
                answer.texts.push({ answerText: option.questionOption });
              }
            });
          } else {
            answer.texts.push({ answerText: group.get(question.questionIdentifier)?.value });
          }
          answers.push(answer);
        });
      });

      const result = {
        formId: this.form.id,
        answers: answers
      };

      console.log(result)

      this.formService.submitFormAnswer(result).subscribe({
        next: () => {
          this.router.navigate(['/home']).then(() => {
            this.errorService.showError('Vyplnenie dotazníka prebehlo úspešne.');
          });
        },
        error: () => {
          this.errorService.showError('Pri vyplnení dotazníka nastala chyba.');
        }
      });
    }
  }
}
