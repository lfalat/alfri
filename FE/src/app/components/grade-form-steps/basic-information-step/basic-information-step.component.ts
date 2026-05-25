import { Component, Input } from '@angular/core';
import { FormQuestionComponent } from '@components/form-question/form-question.component';
import { FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButton } from '@angular/material/button';
import { MatStepLabel, MatStepperNext } from '@angular/material/stepper';
import { Section } from '../../../types';

@Component({
  selector: 'app-basic-information-step',
  standalone: true,
  imports: [
    FormQuestionComponent,
    FormsModule,
    MatButton,
    MatStepLabel,
    ReactiveFormsModule,
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
