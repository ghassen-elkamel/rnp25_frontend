import { Controller, Get, Post, Body, Query } from "@nestjs/common";
import { TracerService } from "./tracer.service";
import { CreateTracerDto } from "./dto/create-tracer.dto";

@Controller("v1/tracer")
export class TracerController {
  constructor(private readonly tracerService: TracerService) {}

  @Post()
  create(@Body() createTracerDto: CreateTracerDto) {
    return this.tracerService.create(createTracerDto);
  }

  @Get()
  findAllBy(@Query() query) {
    return this.tracerService.findAll(query.url);
  }
}
