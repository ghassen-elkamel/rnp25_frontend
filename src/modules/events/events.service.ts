import { Injectable } from '@nestjs/common';
import { CreateEventDto } from './dto/create-event.dto';
import { UpdateEventDto } from './dto/update-event.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Event } from './entities/event.entity';
import { CompanyService } from '../company/company.service';


@Injectable()
export class EventsService {
  constructor(
@InjectRepository(Event)
private repository: Repository<Event>,
private readonly companyService: CompanyService,

  ){}
  async create(createEventDto: CreateEventDto, companyId: number) {
    let company =await this.companyService.findOne(companyId);
createEventDto.company=company;
    return this.repository.save(createEventDto);
  }
  findAll() {
    return this.repository.find();
  }
 async findAllByCompany(companyId: number) {
    let items=await this.repository.find({ where: {company:{id:companyId} 
    } });
    return {items}
  }
  
  findOne(id: number) {
    return this.repository.findOne({ where: { id } });
  }
  
  update(id: number, updateEventDto: UpdateEventDto) {
    return this.repository.update(id, updateEventDto);
  }
  
  remove(id: number) {
    return this.repository.delete(id);
  }}
