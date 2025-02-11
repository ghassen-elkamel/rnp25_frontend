import { Module } from '@nestjs/common';
import { QuestionResponseService } from './question_response.service';
import { QuestionResponseController } from './question_response.controller';

@Module({
  controllers: [QuestionResponseController],
  providers: [QuestionResponseService]
})
export class QuestionResponseModule {}
