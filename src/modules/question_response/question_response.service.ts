import { Injectable } from '@nestjs/common';
import { CreateQuestionResponseDto } from './dto/create-question_response.dto';
import { UpdateQuestionResponseDto } from './dto/update-question_response.dto';

@Injectable()
export class QuestionResponseService {
  create(createQuestionResponseDto: CreateQuestionResponseDto) {
    return 'This action adds a new questionResponse';
  }

  findAll() {
    return `This action returns all questionResponse`;
  }

  findOne(id: number) {
    return `This action returns a #${id} questionResponse`;
  }

  update(id: number, updateQuestionResponseDto: UpdateQuestionResponseDto) {
    return `This action updates a #${id} questionResponse`;
  }

  remove(id: number) {
    return `This action removes a #${id} questionResponse`;
  }
}
