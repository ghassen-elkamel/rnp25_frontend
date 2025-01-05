import { forwardRef, Module } from "@nestjs/common";
import { PassportModule } from "@nestjs/passport";
import { AuthService } from "./auth.service";
import { AuthController } from "./auth.controller";
import { JwtModule } from "@nestjs/jwt";
import { JwtStrategy } from "./strategies/jwt.strategy";
import { ConfigModule } from "@nestjs/config";
import { UsersModule } from "../users/users.module";
import { RefreshAuthStrategy } from "./strategies/refresh.strategy";

@Module({
  imports: [
    ConfigModule.forRoot({}),
    forwardRef(() => UsersModule),
    PassportModule,
    JwtModule.register({
      secret: process.env.JWT_SECRET_KEY,
      signOptions: { expiresIn: process.env.ACCESS_TOKEN_TIMEOUT },
    }),
  ],
  providers: [AuthService, JwtStrategy, RefreshAuthStrategy],
  controllers: [AuthController],
  exports: [AuthService],
})
export class AuthModule {}
