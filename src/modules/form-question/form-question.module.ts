import { Module } from '@nestjs/common';
import { FormQuestionService } from './form-question.service';
import { FormQuestionController } from './form-question.controller';

@Module({
  controllers: [FormQuestionController],
  providers: [FormQuestionService]
})
export class FormQuestionModule {}
