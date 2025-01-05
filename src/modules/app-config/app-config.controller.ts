import { Controller, Get, Post, Body, NotFoundException, Query } from "@nestjs/common";
import { AppConfigService } from "./app-config.service";
import { CreateAppConfigDto } from "./dto/create-app-config.dto";
import { ApiTags } from "@nestjs/swagger";

@ApiTags("App Config")
@Controller("v1/appConfig")
export class AppConfigController {
  constructor(private readonly appConfigService: AppConfigService) {}

  @Post()
  create(@Body() createAppConfigDto: CreateAppConfigDto) {
    return this.appConfigService.create(createAppConfigDto);
  }

  @Get("/create")
  fastCreate(@Query("android") android: string, @Query("ios") ios: string) {
    let createAppConfigDto: CreateAppConfigDto = new CreateAppConfigDto({
      minVersionAndroid: android,
      minVersionIOS: ios,
    });
    return this.appConfigService.create(createAppConfigDto);
  }

  @Get()
  async findAll() {
    let versions = await this.appConfigService.find();
    if (versions.length > 0) {
      return versions[0];
    }
    throw new NotFoundException("version not found");
  }
}
