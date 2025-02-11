import { BadRequestException, forwardRef, Inject, Injectable, NotFoundException } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { comparePassword } from "src/utils/bycrpt.helper";
import { User } from "../users/entities/user.entity";
import { UsersService } from "../users/users.service";
import { AuthDto } from "./dto/auth.dto";
import { Token } from "./entities/token.entity";
import { Company } from "../company/entities/company.entity";

@Injectable()
export class AuthService {
  constructor(
    @Inject(forwardRef(() => UsersService))
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async login(auth: AuthDto, language): Promise<Token | any> {
    let user = await this.usersService.finOneByEmail(auth.email);
    if (!user) throw new BadRequestException("invalidInformation");

    console.log(user.role);
    const matches = await comparePassword(auth.password, user.password);
    if (!matches) {
      throw new BadRequestException("invalidPassword");
    }

    let newUser = await this.usersService.setLanguage(user.id, language);
    user.language = newUser.language;
    await this.usersService.addTokenToUser(auth.fcmToken, user);

    return await this.getTokens(user);
  }

  async refreshTokens(userReq: User) {
    const user = await this.usersService.finOneByEmail(userReq.email);
    if (!user) throw new NotFoundException("invalidInformation");

    return await this.getTokens(user);
  }

  async getTokens(user: User) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        {
          userId: user.id,
          role: user.role.code,
          companyId: user.company?.id,
          language: user.language,
        },
        {
          secret: process.env.JWT_SECRET_KEY,
          expiresIn: process.env.ACCESS_TOKEN_TIMEOUT,
        },
      ),
      this.jwtService.signAsync(
        {
          userId: user.id,
          companyId: user.company?.id,

          role: user.role.code,

          language: user.language,
        },
        {
          secret: process.env.REFRESH_SECRET,
          expiresIn: process.env.REFRESH_TOKEN_TIMEOUT,
        },
      ),
    ]);

    return {
      accessToken,
      refreshToken,
      role: user.role.code,
      userId: user.id,

      language: user.language,
    };
  }
}
