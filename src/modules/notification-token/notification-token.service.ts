import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { CreateNotificationTokenDto } from "./dto/create-notification-token.dto";
import { NotificationToken } from "./entities/notification-token.entity";
import { LogoutDto } from "../auth/dto/logout.dto";

@Injectable()
export class NotificationTokenService {
  constructor(
    @InjectRepository(NotificationToken)
    private repository: Repository<NotificationToken>,
  ) {}

  async addNotificationToken(createNotificationTokenDto: CreateNotificationTokenDto) {
    let countToken: number = await this.repository
      .createQueryBuilder()
      .innerJoinAndSelect(`${NotificationToken.name}.user`, "user")
      .where(`token=:token and ${NotificationToken.name}.userId=:user`, {
        token: createNotificationTokenDto.token,
        user: createNotificationTokenDto.user.id,
      })
      .getCount();

    if (countToken == 0) {
      this.repository.save(createNotificationTokenDto);
    }
  }

  async removeToken(logoutDto: LogoutDto) {
    return await this.repository.softDelete({
      user: { id: logoutDto.userId },
      token: logoutDto.fcmToken,
    });
  }
}
