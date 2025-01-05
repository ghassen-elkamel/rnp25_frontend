import { Injectable, NotFoundException } from "@nestjs/common";
import { Country } from "./entities/country.entity";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";

@Injectable()
export class CountryService {
  constructor(
    @InjectRepository(Country)
    private readonly countryRepository: Repository<Country>,
  ) {}

  async findAll(language: string) {
    const countries = await this.countryRepository.find();

    if (!countries) throw new NotFoundException("Country does not exist");
    countries.map((item) => {
      if (language == "en") {
        item.name = item.nameSecondary;
      }
      if (language == "tr") {
        item.name = item.nameThird;
      }
    });

    return { items: countries };
  }

  async findOne(id: number) {
    const country = await this.countryRepository.findOne({
      where: {
        id: id,
      },
    });
    if (!country) throw new NotFoundException("Country does not exist");
    return country;
  }
}
