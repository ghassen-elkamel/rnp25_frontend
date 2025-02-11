import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { FormQuestionService } from './form-question.service';
import { CreateFormQuestionDto } from './dto/create-form-question.dto';
import { UpdateFormQuestionDto } from './dto/update-form-question.dto';

@Controller('form-question')
export class FormQuestionController {
  constructor(private readonly formQuestionService: FormQuestionService) {}

  @Post()
  create(@Body() createFormQuestionDto: CreateFormQuestionDto) {
    return this.formQuestionService.create(createFormQuestionDto);
  }

  @Get()
  findAll() {
    return this.formQuestionService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.formQuestionService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateFormQuestionDto: UpdateFormQuestionDto) {
    return this.formQuestionService.update(+id, updateFormQuestionDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.formQuestionService.remove(+id);
  }
}
