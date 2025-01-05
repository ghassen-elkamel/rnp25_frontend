import { Controller, Get, Headers, Param, Patch, Post, Query, Req, UseGuards } from "@nestjs/common";
import { NotificationsService } from "./notifications.service";
import { ApiTags, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { PageOptionsDto } from "src/common/dto/page-options.dto";

@Controller("v1/notification")
@ApiTags("notification")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}
  @Get()
  findAll(@Req() req, @Query() pageOptionsDto: PageOptionsDto) {
    let userId = req.user.userId;
    return this.notificationsService.findMyNotifications({
      pageOptionsDto: pageOptionsDto,
      userId: userId,
    });
  }

  @Patch(":id")
  viewNotification(@Param("id") id: string) {
    return this.notificationsService.viewNotification(+id);
  }
}
