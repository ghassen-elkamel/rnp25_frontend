import { ApiProperty } from "@nestjs/swagger";
import { IsEmail, IsNotEmpty } from "class-validator";
import { CreateUserDto } from "./create-user.dto";
export class UpdateUserDto extends CreateUserDto {
  @ApiProperty()
  @IsNotEmpty()
  id: number;
}
