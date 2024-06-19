import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SubjectsClusteringComponent } from './subjects-clustering.component';

describe('SubjectsClusteringComponent', () => {
  let component: SubjectsClusteringComponent;
  let fixture: ComponentFixture<SubjectsClusteringComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SubjectsClusteringComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(SubjectsClusteringComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
