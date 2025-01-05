import { Controller, Get, Headers, Param, Query, UseGuards } from "@nestjs/common";
import { RegionService } from "./region.service";
import { ApiTags, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { Public } from "src/decorators/public.decorator";

@Controller("v1/region")
@ApiTags("region")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
export class RegionController {
  constructor(private readonly regionService: RegionService) {}

  @Public()
  @Get()
  findAll(@Query("countryId") countryId: number, @Headers() headers) {
    let language: string = headers.language;
    return this.regionService.findAll({ countryId, language });
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.regionService.findOne(+id);
  }
}
