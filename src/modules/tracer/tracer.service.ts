import { Injectable } from "@nestjs/common";
import { CreateTracerDto } from "./dto/create-tracer.dto";
import { InjectRepository } from "@nestjs/typeorm";
import { Tracer } from "./entities/tracer.entity";
import { Like, Not, Repository } from "typeorm";

@Injectable()
export class TracerService {
  constructor(
    @InjectRepository(Tracer)
    private repository: Repository<Tracer>,
  ) {}
  async create(createTracerDto: CreateTracerDto) {
    return await this.repository.save(createTracerDto);
  }

  async findAll(url?: string) {
    let where = {};

    if (url) {
      where = { url: Like(`%${url}%`) && Not(Like(`%tracer%`)) };
    }

    return await this.repository.find({
      where: where,
      order: {
        createdAt: "desc",
      },
    });
  }
}
