import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MandatorySubjectsStepComponent } from './mandatory-subjects-step.component';

describe('MandatorySubjectsStepComponent', () => {
  let component: MandatorySubjectsStepComponent;
  let fixture: ComponentFixture<MandatorySubjectsStepComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MandatorySubjectsStepComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(MandatorySubjectsStepComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
