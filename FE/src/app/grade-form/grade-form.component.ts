import { Component, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatStep, MatStepLabel, MatStepper, MatStepperNext, MatStepperPrevious } from '@angular/material/stepper';
import { MatCheckbox } from '@angular/material/checkbox';
import { MatButton } from '@angular/material/button';
import { MatFormField, MatLabel } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { KeyValuePipe, NgForOf } from '@angular/common';
import { MatSlider, MatSliderThumb } from '@angular/material/slider';

interface InterestCategories {
  [key: string]: string[];
}

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
    MatSliderThumb
  ],
  templateUrl: './grade-form.component.html',
  styleUrl: './grade-form.component.scss'
})
export class GradeFormComponent implements OnInit {
  formGroup: FormGroup;
  subjects = ['PaS', 'DP', 'AaUS1', 'ATG', 'MatAl1', 'INF2'];
  areas = ['matematika', 'dizajn', 'hardware', 'testovanie', 'logika', 'ekonomika', 'siete', 'jazyky',
    'programovanie', 'manazment', 'data', 'fyzickaZataz'];
  interestCategories: InterestCategories = {
    Šport: ['Futbal', 'Basketbal', 'Tenis'],
    Umenie: ['Hudba', 'Kreslenie', 'Maľovanie'],
    Veda: ['Fyzika', 'Chémia', 'Biológia'],
    Tech: ['Programovanie', 'Robotika', 'Siete'],
    Iné: ['Cestovanie', 'Fotografovanie', 'Čítanie']
  };

  constructor(private fb: FormBuilder) {
    this.formGroup = this.fb.group({
      step1: this.fb.group({
        fakulta: ['', Validators.required],
        odbor: ['', Validators.required],
        rocnik: ['', Validators.required],
        meno: [''],
        priezvisko: ['']
      }),
      step2: this.fb.group({
        ...this.subjects.reduce((acc, subject) => ({ ...acc, [subject]: this.fb.control('', Validators.required) }), {})
      }),
      step3: this.fb.group({
        ...this.areas.reduce((acc, subject) => ({ ...acc, [subject]: this.fb.control(1, Validators.required) }), {})
      }),
      step4: this.fb.group({
        interests: this.fb.array(Object.values(this.interestCategories).flat().map(() => this.fb.control(false)))
      })
    });
  }

  ngOnInit(): void {
    console.log(this.formGroup.controls)
  }


  get step1() {
    return this.formGroup.get('step1') as FormGroup;
  }

  get step2() {
    return this.formGroup.get('step2') as FormGroup;
  }

  get step3() {
    return this.formGroup.get('step3') as FormGroup;
  }

  get step4() {
    return this.formGroup.get('step4') as FormGroup;
  }

  get grades() {
    return this.step2.get('grades') as FormArray;
  }

  get interestsArray() {
    return this.step4.get('interests') as FormArray;
  }

  getInterestControls(category: string) {
    const startIndex = Object.keys(this.interestCategories).slice(0, Object.keys(this.interestCategories)
      .indexOf(category)).reduce((acc, key) => acc + this.interestCategories[key].length, 0);
    const endIndex: number = startIndex + this.interestCategories[category].length;
    return this.interestsArray.controls.slice(startIndex, endIndex) as FormControl[];
  }
}
