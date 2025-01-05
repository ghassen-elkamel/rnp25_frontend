import { User } from "src/modules/users/entities/user.entity";

export class CreateNotificationTokenDto {
  token: string;
  user: User;
  constructor({ user, token }) {
    this.user = user;
    this.token = token;
  }
}
