import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FormQuestionComponent } from './form-question.component';

describe('FormQuestionComponent', () => {
  let component: FormQuestionComponent;
  let fixture: ComponentFixture<FormQuestionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FormQuestionComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(FormQuestionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
