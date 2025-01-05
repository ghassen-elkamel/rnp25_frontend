import { Controller, Get, Query, Res } from "@nestjs/common";
import { AppService } from "./app.service";
import { Public } from "./decorators/public.decorator";

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
