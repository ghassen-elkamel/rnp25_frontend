import { Module } from '@nestjs/common';
import { EventsService } from './events.service';
import { EventsController } from './events.controller';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Event } from './entities/event.entity';
import { CompanyModule } from '../company/company.module';

@Module({
  imports : [TypeOrmModule.forFeature([Event]),CompanyModule],
  controllers: [EventsController],
  providers: [EventsService]
})
export class EventsModule {}
