import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Section } from '../../../types';
import { FormGroup, ReactiveFormsModule } from '@angular/forms';
import { FormQuestionComponent } from '@components/form-question/form-question.component';
import { MatButton } from '@angular/material/button';
import { MatStepLabel, MatStepperPrevious } from '@angular/material/stepper';

@Component({
  selector: 'app-hobby-step',
  standalone: true,
  imports: [
    FormQuestionComponent,
    MatButton,
    MatStepperPrevious,
    ReactiveFormsModule,
    MatStepLabel,
  ],
  templateUrl: './hobby-step.component.html',
  styleUrl: './hobby-step.component.scss',
})
export class HobbyStepComponent {
  @Input() section!: Section;
  @Input() currentFormGroup!: FormGroup;
  @Input() basicInformationFormGroup!: FormGroup;
  @Output() submitForm = new EventEmitter<unknown>();

  submit() {
    this.submitForm.emit();
  }
}
