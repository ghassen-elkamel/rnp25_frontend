import { Inject, Injectable, forwardRef } from "@nestjs/common";
import { CreateCompanyDto } from "./dto/create-company.dto";
import { Repository } from "typeorm";
import { InjectRepository } from "@nestjs/typeorm";
import { Company } from "./entities/company.entity";
import { CreateFullCompanyDto } from "./dto/create-full-company.dto";

import { CreateUserDto } from "../users/dto/create-user.dto";
import { RolesType } from "src/enums/roles.enum";
import { Role } from "../users/entities/role.entity";
import { UsersService } from "../users/users.service";
import { encodePassword } from "src/utils/bycrpt.helper";
import { RegionService } from "../region/region.service";

@Injectable()
export class CompanyService {
  constructor(
    @InjectRepository(Company)
    private repository: Repository<Company>,

    @Inject(forwardRef(() => UsersService))
    private usersService: UsersService,
    private readonly regionService: RegionService,
  ) {}

  async create(createFullCompanyDto: CreateFullCompanyDto, userId, file: Express.Multer.File) {
    let createCompanyDto: CreateCompanyDto = new CreateCompanyDto(userId);
    createCompanyDto.name = createFullCompanyDto.companyName;
    createCompanyDto.imagePath = file?.filename;
    let region = await this.regionService.findOne(+createFullCompanyDto.regionId);
    createCompanyDto.region = region;
    let company = this.repository.create(createCompanyDto);

    let createUserDto: CreateUserDto = new CreateUserDto();
    createUserDto.phoneNumber = createFullCompanyDto.phoneNumber;
    createUserDto.countryCode = createFullCompanyDto.countryCode;
    createUserDto.fullName = createFullCompanyDto.fullName;
    createUserDto.role = new Role(RolesType.admin);
    createUserDto.company = company;
    createUserDto.email = createFullCompanyDto.email;
    const user = await this.usersService.create(createUserDto);
    const password = user.password;
    await this.repository.save(company);
    user.password = await encodePassword(user.password);
    const newUser = await this.usersService.saveChanges(user);

    newUser.password = password;
    return newUser;
  }

  async findAll() {
    let items = await this.repository.find();
    return { items };
  }

  findOne(companyId: number): Company | PromiseLike<Company> {
    return this.repository.findOne({
      where: {
        id: companyId,
      },
    });
  }

  async findCurrentCompany(companyId: number): Promise<Company | PromiseLike<Company>> {
    return await this.repository.findOne({
      where: {
        id: companyId,
      },
    });
  }
}
