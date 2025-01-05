import { ExtractJwt, Strategy } from "passport-jwt";
import { PassportStrategy } from "@nestjs/passport";
import { Injectable, UnauthorizedException } from "@nestjs/common";
import { UsersService } from "src/modules/users/users.service";

@Injectable()
export class RefreshAuthStrategy extends PassportStrategy(Strategy, "jwt-refresh") {
  constructor(private userService: UsersService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.REFRESH_SECRET,
    });
  }

  async validate(payload: any) {
    const user = await this.userService.findOne(payload.userId);

    if (!user) {
      throw new UnauthorizedException();
    }
    return user;
  }
}
