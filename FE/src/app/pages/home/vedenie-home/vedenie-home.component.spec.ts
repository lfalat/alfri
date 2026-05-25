import { ComponentFixture, TestBed } from '@angular/core/testing';

import { VedenieHomeComponent } from './vedenie-home.component';

describe('VedenieHomeComponent', () => {
  let component: VedenieHomeComponent;
  let fixture: ComponentFixture<VedenieHomeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [VedenieHomeComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(VedenieHomeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
