import { Inject, Injectable, forwardRef, Req } from "@nestjs/common";
import { CreateCompanyDto } from "./dto/create-company.dto";
import { UpdateCompanyDto } from "./dto/update-company.dto";
import { Repository } from "typeorm";
import { InjectRepository } from "@nestjs/typeorm";
import { Company } from "./entities/company.entity";
import { CreateFullCompanyDto } from "./dto/create-full-company.dto";
import { BranchService } from "../branch/branch.service";
import { CreateBranchDto } from "../branch/dto/create-branch.dto";
import { Branch } from "../branch/entities/branch.entity";
import { CreateUserDto } from "../users/dto/create-user.dto";
import { RolesType } from "src/enums/roles.enum";
import { Role } from "../users/entities/role.entity";
import { UsersService } from "../users/users.service";

@Injectable()
export class CompanyService {
  constructor(
    @InjectRepository(Company)
    private repository: Repository<Company>,
    @Inject(forwardRef(() => BranchService))
    private branchService: BranchService,
    @Inject(forwardRef(() => UsersService))
    private usersService: UsersService,
  ) {}

  async create(createFullCompanyDto: CreateFullCompanyDto, userId, file: Express.Multer.File) {
    let createCompanyDto: CreateCompanyDto = new CreateCompanyDto(userId);
    createCompanyDto.name = createFullCompanyDto.companyName;
    createCompanyDto.imagePath = file?.filename;

    let company = await this.repository.save(createCompanyDto);

    let createBranchDto: CreateBranchDto = new CreateBranchDto(userId);
    createBranchDto.company = company;
    createBranchDto.regionId = createFullCompanyDto.branchRegionId;
    createBranchDto.position = createFullCompanyDto.branchPosition;
    createBranchDto.name = createFullCompanyDto.branchName;

    let branch: Branch = await this.branchService.create(createBranchDto);

    let createUserDto: CreateUserDto = new CreateUserDto();
    createUserDto.username = createFullCompanyDto.username;
    createUserDto.firstName = createFullCompanyDto.firstName;
    createUserDto.lastName = createFullCompanyDto.lastName;
    createUserDto.phoneNumber = createFullCompanyDto.phoneNumber;
    createUserDto.countryCode = createFullCompanyDto.countryCode;
    createUserDto.branch = branch;
    createUserDto.role = new Role(RolesType.admin);

    return this.usersService.create(createUserDto);
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
