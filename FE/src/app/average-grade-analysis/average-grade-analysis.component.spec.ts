import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AverageGradeAnalysisComponent } from './average-grade-analysis.component';

describe('AverageGradeAnalysisComponent', () => {
  let component: AverageGradeAnalysisComponent;
  let fixture: ComponentFixture<AverageGradeAnalysisComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AverageGradeAnalysisComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(AverageGradeAnalysisComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
