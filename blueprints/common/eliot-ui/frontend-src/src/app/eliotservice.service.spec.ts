import { TestBed } from '@angular/core/testing';

import { EliotserviceService } from './eliotservice.service';

describe('EliotserviceService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: EliotserviceService = TestBed.get(EliotserviceService);
    expect(service).toBeTruthy();
  });
});
