import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PassingPredictionComponent } from './passing-prediction.component';

describe('PassingPredictionComponent', () => {
  let component: PassingPredictionComponent;
  let fixture: ComponentFixture<PassingPredictionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PassingPredictionComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(PassingPredictionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
