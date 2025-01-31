import { Component, Input } from '@angular/core';
import { FormQuestionComponent } from '@components/form-question/form-question.component';
import { FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButton } from '@angular/material/button';
import { MatStep, MatStepLabel, MatStepperNext, MatStepperPrevious } from '@angular/material/stepper';
import { NgClass, NgForOf, NgIf } from '@angular/common';
import { Section } from '../../../types';

@Component({
  selector: 'app-basic-information-step',
  standalone: true,
  imports: [
    FormQuestionComponent,
    FormsModule,
    MatButton,
    MatStep,
    MatStepLabel,
    NgForOf,
    ReactiveFormsModule,
    NgIf,
    NgClass,
    MatStepperPrevious,
    MatStepperNext,
  ],
  templateUrl: './basic-information-step.component.html',
  styleUrl: './basic-information-step.component.scss',
})
export class BasicInformationStepComponent {
  @Input() section!: Section;
  @Input() formGroup!: FormGroup;

  constructor() {}
}
