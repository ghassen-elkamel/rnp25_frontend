import { Test, TestingModule } from '@nestjs/testing';
import { FormResponseController } from './form_response.controller';
import { FormResponseService } from './form_response.service';

describe('FormResponseController', () => {
  let controller: FormResponseController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [FormResponseController],
      providers: [FormResponseService],
    }).compile();

    controller = module.get<FormResponseController>(FormResponseController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
