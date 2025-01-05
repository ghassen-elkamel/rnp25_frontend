import { Inject, Injectable, NotFoundException, forwardRef } from "@nestjs/common";
import { CreateBranchDto } from "./dto/create-branch.dto";
import { UpdateBranchDto } from "./dto/update-branch.dto";
import { Branch } from "./entities/branch.entity";
import { FindOneOptions, FindOptionsRelations, Repository } from "typeorm";
import { RegionService } from "../region/region.service";
import { CompanyService } from "../company/company.service";
import { InjectRepository } from "@nestjs/typeorm";

@Injectable()
export class BranchService {
  constructor(
    @InjectRepository(Branch)
    private repository: Repository<Branch>,
    private regionService: RegionService,
    @Inject(forwardRef(() => CompanyService))
    private companyService: CompanyService,
  ) {}
  async create(createBranchDto: CreateBranchDto) {
    if (!createBranchDto.company) {
      createBranchDto.company = await this.companyService.findOne(createBranchDto.companyId);
    }

    if (!createBranchDto.region) {
      createBranchDto.region = await this.regionService.findOne(createBranchDto.regionId);
    }
    const branch = await this.repository.save(createBranchDto);
    return branch;
  }

  findPrincipal(companyId: number) {
    return this.repository.findOne({
      where: {
        company: { id: companyId },
        haveUserAccounts: true,
      },
    });
  }

  async findAll(args: { companyId; withCompany; withCountry }) {
    let items = await this.repository.find({
      where: {
        company: {
          id: args.companyId,
        },
      },
      relations: {
        company: args.withCompany,
        region: {
          country: args.withCountry,
        },
      },
    });
    return { items };
  }

  async findAllWithCurrency() {
    let items = await this.repository.find();
    return { items };
  }

  findOne(id: number, args?: { relations: FindOptionsRelations<Branch> }) {
    if (!id) {
      throw new NotFoundException("Branch not found");
    }
    return this.repository.findOne({
      where: {
        id: id,
      },
      relations: args?.relations ?? {},
    });
  }
  findAllByCompany(companyId: number) {
    return this.repository.find({
      where: {
        company: {
          id: companyId,
        },
      },
    });
  }

  deleteBranch(id: number) {
    return this.repository.softDelete({ id: id });
  }

  async update(branch: Branch) {
    return this.repository.save(branch);
  }
}
