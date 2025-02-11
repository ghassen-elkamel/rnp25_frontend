import { Optional } from "@nestjs/common";
import { ApiProperty } from "@nestjs/swagger";

export class AuthDto {
  @ApiProperty()
  @Optional()
  email: string;

  @ApiProperty()
  @Optional()
  password: string;

  @ApiProperty()
  fcmToken: string;
}
