import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StudentMarksReportComponent } from './student-marks-report.component';

describe('StudentMarksReportComponent', () => {
  let component: StudentMarksReportComponent;
  let fixture: ComponentFixture<StudentMarksReportComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [StudentMarksReportComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(StudentMarksReportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
