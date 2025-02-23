import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FocusStepComponent } from './focus-step.component';

describe('FocusStepComponent', () => {
  let component: FocusStepComponent;
  let fixture: ComponentFixture<FocusStepComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FocusStepComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(FocusStepComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
