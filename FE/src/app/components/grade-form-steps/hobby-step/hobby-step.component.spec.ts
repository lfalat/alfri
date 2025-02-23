import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HobbyStepComponent } from './hobby-step.component';

describe('HobbyStepComponent', () => {
  let component: HobbyStepComponent;
  let fixture: ComponentFixture<HobbyStepComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [HobbyStepComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(HobbyStepComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
