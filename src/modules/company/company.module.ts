import { Module, forwardRef } from "@nestjs/common";
import { CompanyService } from "./company.service";
import { CompanyController } from "./company.controller";
import { TypeOrmModule } from "@nestjs/typeorm";
import { Company } from "./entities/company.entity";
import { BranchModule } from "../branch/branch.module";
import { UsersModule } from "../users/users.module";

@Module({
  imports: [TypeOrmModule.forFeature([Company]), forwardRef(() => BranchModule), forwardRef(() => UsersModule)],
  controllers: [CompanyController],
  providers: [CompanyService],
  exports: [CompanyService],
})
export class CompanyModule {}
