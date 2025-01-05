import { Module, forwardRef } from "@nestjs/common";
import { BranchService } from "./branch.service";
import { BranchController } from "./branch.controller";
import { TypeOrmModule } from "@nestjs/typeorm";
import { Branch } from "./entities/branch.entity";
import { RegionModule } from "../region/region.module";
import { CompanyModule } from "../company/company.module";

@Module({
  imports: [TypeOrmModule.forFeature([Branch]), RegionModule, forwardRef(() => CompanyModule)],
  controllers: [BranchController],
  providers: [BranchService],
  exports: [BranchService],
})
export class BranchModule {}
