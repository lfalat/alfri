import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SubjectsTableComponent } from './subjects-table.component';

describe('SubjectsTableComponent', () => {
  let component: SubjectsTableComponent;
  let fixture: ComponentFixture<SubjectsTableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SubjectsTableComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(SubjectsTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
