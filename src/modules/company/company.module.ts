import { Module, forwardRef } from "@nestjs/common";
import { CompanyService } from "./company.service";
import { CompanyController } from "./company.controller";
import { TypeOrmModule } from "@nestjs/typeorm";
import { Company } from "./entities/company.entity";

import { UsersModule } from "../users/users.module";
import { RegionModule } from "../region/region.module";

@Module({
  imports: [TypeOrmModule.forFeature([Company]),  forwardRef(() => UsersModule),RegionModule],
  controllers: [CompanyController],
  providers: [CompanyService],
  exports: [CompanyService],
})
export class CompanyModule {}
