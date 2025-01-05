import { ApiProperty } from "@nestjs/swagger";
import { IsEmail, IsEmpty, IsEnum, IsNotEmpty, IsOptional } from "class-validator";
import { RolesType } from "src/enums/roles.enum";
import { AuthDto } from "src/modules/auth/dto/auth.dto";
import { Branch } from "src/modules/branch/entities/branch.entity";
import { Role } from "src/modules/users/entities/role.entity";

export class CreateUserDto extends AuthDto {
  @ApiProperty()
  @IsOptional()
  externalCode: string;

  @ApiProperty()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty()
  @IsOptional()
  lastName: string;

  @ApiProperty()
  @IsOptional()
  @IsEmail({}, { message: "Adresse e-mail invalide" })
  email: string;

  @ApiProperty()
  @IsOptional()
  phoneNumber: string;

  @ApiProperty()
  @IsNotEmpty()
  countryCode: string;

  @ApiProperty()
  @IsEmpty()
  branch: Branch;

  @ApiProperty()
  @IsOptional()
  branchId: number;

  @ApiProperty()
  @IsOptional()
  @IsEnum(RolesType)
  receivedRole: RolesType;

  @IsEmpty()
  role: Role;

  @IsEmpty()
  isVerified: boolean;

  @IsEmpty()
  isActive: boolean;

  @IsEmpty()
  isBlocked: boolean;

  @ApiProperty()
  fcmToken: string;

  @ApiProperty()
  language: string;
}
