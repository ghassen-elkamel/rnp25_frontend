import { Controller, Get, Post, Body, UseGuards, Req, Headers } from "@nestjs/common";
import { ApiBearerAuth, ApiTags } from "@nestjs/swagger";
import { AuthService } from "./auth.service";
import { AuthDto } from "./dto/auth.dto";
import { Token } from "./entities/token.entity";
import { RefreshTokenGuard } from "./guards/refresh-token.guard";

@ApiTags("auth")
@Controller("v1/auth/")
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post("login")
  async login(@Body() auth: AuthDto, @Headers() headers): Promise<Token | any> {
    let language: string = headers.language;
    return this.authService.login(auth, language);
  }

  @Post("loginTV")
  async loginTV(@Body() auth: AuthDto, @Headers() headers): Promise<Token | any> {
    let language: string = headers.language;
    auth.username = "mypartner";
    auth.password = "1234";
    return await this.authService.login(auth, language);
  }

  @ApiBearerAuth()
  @UseGuards(RefreshTokenGuard)
  @Get("refresh")
  async refreshTokens(@Req() req) {
    return this.authService.refreshTokens(req.user);
  }
}
