import { Controller, Get, Post, Body, UseGuards, Req, Query } from "@nestjs/common";
import { BranchService } from "./branch.service";
import { CreateBranchDto } from "./dto/create-branch.dto";
import { ApiTags, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { RolesType } from "src/enums/roles.enum";

@Controller("v1/branch")
@ApiTags("branch")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
export class BranchController {
  constructor(private readonly branchService: BranchService) {}

  @Post()
  create(@Body() createBranchDto: CreateBranchDto, @Req() req) {
    let userId = req.user.userId;
    createBranchDto.setCreationInfo(userId);
    return this.branchService.create(createBranchDto);
  }

  @Get("all")
  findAll(@Req() req, @Query("withCompany") withCompany?: boolean, @Query("withCountry") withCountry?: boolean) {
    let companyId: number = req.user.companyId;

    return this.branchService.findAll({ companyId, withCompany, withCountry });
  }
}
