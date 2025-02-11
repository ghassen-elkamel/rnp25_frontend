import { Injectable } from '@nestjs/common';
import { CreateFormQuestionDto } from './dto/create-form-question.dto';
import { UpdateFormQuestionDto } from './dto/update-form-question.dto';

@Injectable()
export class FormQuestionService {
  create(createFormQuestionDto: CreateFormQuestionDto) {
    return 'This action adds a new formQuestion';
  }

  findAll() {
    return `This action returns all formQuestion`;
  }

  findOne(id: number) {
    return `This action returns a #${id} formQuestion`;
  }

  update(id: number, updateFormQuestionDto: UpdateFormQuestionDto) {
    return `This action updates a #${id} formQuestion`;
  }

  remove(id: number) {
    return `This action removes a #${id} formQuestion`;
  }
}
