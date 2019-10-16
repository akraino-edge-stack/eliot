import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReplicaComponent } from './replica.component';

describe('ReplicaComponent', () => {
  let component: ReplicaComponent;
  let fixture: ComponentFixture<ReplicaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReplicaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReplicaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
