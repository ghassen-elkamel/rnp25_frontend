import { PartialType } from '@nestjs/swagger';
import { CreateQuestionResponseDto } from './create-question_response.dto';

export class UpdateQuestionResponseDto extends PartialType(CreateQuestionResponseDto) {}
