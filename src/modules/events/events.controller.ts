import { Controller, Get, Post, Body, Patch, Param, Delete, UploadedFile, Req, UseGuards, Headers } from '@nestjs/common';
import { EventsService } from './events.service';
import { CreateEventDto } from './dto/create-event.dto';
import { UpdateEventDto } from './dto/update-event.dto';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ApiFile } from 'src/decorators/api-file.decorator';
import { FileSizeValidationPipe } from 'src/pipes/file-max-size.pipe';
import { FileTypeValidationPipe } from 'src/pipes/file-type-validation.pipe';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags("events")
@ApiBearerAuth()
@Controller('v1/events')
@UseGuards(JwtAuthGuard)
export class EventsController {
  constructor(private readonly eventsService: EventsService) {}

  @Post()
    @ApiFile(process.env.UPLOAD_DIR + process.env.UPLOAD_EVENTS_DIR)
  
  create(@Body() createEventDto: CreateEventDto,
  @Req() req,
      @UploadedFile(FileSizeValidationPipe, FileTypeValidationPipe)
      file: Express.Multer.File,
) {
  createEventDto.pathPicture = file?.filename;
  
  let userId = req.user.userId;
  const companyId = req.user.companyId;

  createEventDto.setCreationInfo(userId);
    return this.eventsService.create(createEventDto, companyId);
  }
  @Get('company')
  findAllByCompany(
@Req()req
  ){
    const companyId = req.user.companyId;
    return this.eventsService.findAllByCompany(companyId);

  }

  @Get()
  findAll() {
    return this.eventsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.eventsService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateEventDto: UpdateEventDto) {
    return this.eventsService.update(+id, updateEventDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.eventsService.remove(+id);
  }
}
