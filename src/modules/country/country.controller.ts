import { Controller, Get, Headers, Param, Query, UseGuards } from "@nestjs/common";
import { CountryService } from "./country.service";
import { ApiTags, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { Public } from "src/decorators/public.decorator";

@Controller("v1/country")
@ApiTags("country")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
export class CountryController {
  constructor(private readonly countryService: CountryService) {}

  @Public()
  @Get()
  findAll(@Headers() headers) {
    let language: string = headers.language;
    return this.countryService.findAll(language);
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.countryService.findOne(+id);
  }
}
