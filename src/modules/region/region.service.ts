import { Region } from "./entities/region.entity";
import { Repository } from "typeorm";
import { InjectRepository } from "@nestjs/typeorm";
import { Injectable, NotFoundException } from "@nestjs/common";

@Injectable()
export class RegionService {
  constructor(
    @InjectRepository(Region)
    private readonly regionRepository: Repository<Region>,
  ) {}

  async findAll(args: { countryId: number; language: string }) {
    const regions = await this.regionRepository.find({
      where: {
        countryId: args.countryId,
      },
    });

    if (!regions) throw new NotFoundException("Region does not exist");

    regions.map((item) => {
      if (args.language == "en") {
        item.name = item.nameSecondary;
      }
      if (args.language == "tr") {
        item.name = item.nameThird;
      }
    });

    return { items: regions };
  }

  async findOne(id: number) {
    const region = await this.regionRepository.findOne({
      where: {
        id: id,
      },
    });
    if (!region) throw new NotFoundException("Region does not exist");
    return region;
  }
}
