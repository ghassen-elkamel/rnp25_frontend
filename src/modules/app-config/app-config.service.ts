import { Injectable } from "@nestjs/common";
import { CreateAppConfigDto } from "./dto/create-app-config.dto";
import { AppConfig } from "./entities/app-config.entity";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { Order } from "src/enums/order.enum";

@Injectable()
export class AppConfigService {
  constructor(
    @InjectRepository(AppConfig)
    private repository: Repository<AppConfig>,
  ) {}

  create(createAppConfigDto: CreateAppConfigDto) {
    return this.repository.save(createAppConfigDto);
  }

  find() {
    return this.repository.find({
      order: {
        creationDate: Order.DESC,
      },
      take: 1,
    });
  }
}
