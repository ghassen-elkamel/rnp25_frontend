import { forwardRef, Module } from "@nestjs/common";
import { UsersService } from "./users.service";
import { UsersController } from "./users.controller";
import { TypeOrmModule } from "@nestjs/typeorm";
import { User } from "./entities/user.entity";
import { BranchModule } from "../branch/branch.module";
import { NotificationsModule } from "../notifications/notifications.module";
import { NotificationTokenModule } from "../notification-token/notification-token.module";

@Module({
  imports: [
    TypeOrmModule.forFeature([User]),
    NotificationTokenModule,
    forwardRef(() => NotificationsModule),
    BranchModule,
  ],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
