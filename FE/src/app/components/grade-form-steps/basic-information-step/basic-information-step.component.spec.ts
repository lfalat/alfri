import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BasicInformationStepComponent } from './basic-information-step.component';

describe('BasicInformationStepComponent', () => {
  let component: BasicInformationStepComponent;
  let fixture: ComponentFixture<BasicInformationStepComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BasicInformationStepComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(BasicInformationStepComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
