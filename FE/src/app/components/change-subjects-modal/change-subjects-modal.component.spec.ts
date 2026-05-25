import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangeSubjectsModalComponent } from './change-subjects-modal.component';

describe('ChangeSubjectsModalComponent', () => {
  let component: ChangeSubjectsModalComponent;
  let fixture: ComponentFixture<ChangeSubjectsModalComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ChangeSubjectsModalComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(ChangeSubjectsModalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
