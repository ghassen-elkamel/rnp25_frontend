import { ApiProperty } from "@nestjs/swagger";
import { IsEmpty, IsNotEmpty } from "class-validator";

export class LogoutDto {
  @ApiProperty()
  @IsNotEmpty()
  fcmToken: string;

  @IsEmpty()
  userId: number;
}
