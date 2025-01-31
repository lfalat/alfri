import { ChangeDetectionStrategy, Component, computed, effect, Input, signal } from '@angular/core';
import { QuestionTypes } from '@pages/grade-form/grade-form-types';
import { GradeFormUtil } from '@pages/grade-form/grade-form-util';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatCheckbox } from '@angular/material/checkbox';
import { MatError, MatFormField, MatLabel } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { MatList, MatListItem } from '@angular/material/list';
import { MatOption } from '@angular/material/autocomplete';
import { MatRadioButton, MatRadioGroup } from '@angular/material/radio';
import { MatSelect } from '@angular/material/select';
import { MatSlider, MatSliderThumb } from '@angular/material/slider';
import { NgForOf, NgIf, NgSwitch, NgSwitchCase } from '@angular/common';
import { Question } from '../../types';

@Component({
  selector: 'app-form-question',
  standalone: true,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [
    FormsModule,
    MatCheckbox,
    MatError,
    MatFormField,
    MatInput,
    MatLabel,
    MatList,
    MatListItem,
    MatOption,
    MatRadioButton,
    MatRadioGroup,
    MatSelect,
    MatSlider,
    MatSliderThumb,
    NgForOf,
    NgIf,
    NgSwitchCase,
    NgSwitch,
    ReactiveFormsModule,
  ],
  templateUrl: './form-question.component.html',
  styleUrl: './form-question.component.scss',
})
export class FormQuestionComponent {
  protected readonly QuestionTypes = QuestionTypes;
  protected readonly GradeFormUtil = GradeFormUtil;

  // @Input() question!: Question;
  @Input() formGroup!: FormGroup;

  private _question = signal<Question>({
    id: 0,
    questionTitle: '',
    answerType: 'TEXT',
    optional: false,
    questionIdentifier: '',
    positionInQuestionnaire: 0,
    options: [],
  });
  @Input({ required: true, transform: (q: Question) => q }) set question(value: Question) {
    this._question.set(value);
  }

  questionComputed = computed(() => this._question());

  constructor() {
    effect(() => {
      console.log('Question changed:', this.questionComputed());
    });
  }


  get control(): FormControl {
    return this.formGroup.get(this.questionComputed().questionIdentifier) as FormControl;
  }
}
