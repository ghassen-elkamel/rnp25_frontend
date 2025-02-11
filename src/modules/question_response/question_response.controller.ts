import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { QuestionResponseService } from './question_response.service';
import { CreateQuestionResponseDto } from './dto/create-question_response.dto';
import { UpdateQuestionResponseDto } from './dto/update-question_response.dto';

@Controller('question-response')
export class QuestionResponseController {
  constructor(private readonly questionResponseService: QuestionResponseService) {}

  @Post()
  create(@Body() createQuestionResponseDto: CreateQuestionResponseDto) {
    return this.questionResponseService.create(createQuestionResponseDto);
  }

  @Get()
  findAll() {
    return this.questionResponseService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.questionResponseService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateQuestionResponseDto: UpdateQuestionResponseDto) {
    return this.questionResponseService.update(+id, updateQuestionResponseDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.questionResponseService.remove(+id);
  }
}
