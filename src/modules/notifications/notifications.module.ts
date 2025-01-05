import { forwardRef, Module } from "@nestjs/common";
import { NotificationsService } from "./notifications.service";
import { NotificationsController } from "./notifications.controller";
import { UsersModule } from "../users/users.module";
import { TypeOrmModule } from "@nestjs/typeorm";
import { NotificationEntity } from "./entities/notification-model.entity";
import { Notification } from "./entities/notification.entity";

@Module({
  imports: [
    TypeOrmModule.forFeature([NotificationEntity]),
    TypeOrmModule.forFeature([Notification]),
    forwardRef(() => UsersModule),
  ],
  controllers: [NotificationsController],
  providers: [NotificationsService],
  exports: [NotificationsService],
})
export class NotificationsModule {}
