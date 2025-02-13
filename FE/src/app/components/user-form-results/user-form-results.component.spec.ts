import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UserFormResultsComponent } from './user-form-results.component';

describe('UserFormResultsComponent', () => {
  let component: UserFormResultsComponent;
  let fixture: ComponentFixture<UserFormResultsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [UserFormResultsComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(UserFormResultsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
