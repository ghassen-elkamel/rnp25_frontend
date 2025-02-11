import { Module } from '@nestjs/common';
import { FormResponseService } from './form_response.service';
import { FormResponseController } from './form_response.controller';

@Module({
  controllers: [FormResponseController],
  providers: [FormResponseService]
})
export class FormResponseModule {}
