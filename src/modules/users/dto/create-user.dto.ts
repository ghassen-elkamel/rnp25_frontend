import { ApiProperty } from "@nestjs/swagger";
import { IsEmail, IsEmpty, IsEnum, IsNotEmpty, IsOptional } from "class-validator";
import { RolesType } from "src/enums/roles.enum";
import { AuthDto } from "src/modules/auth/dto/auth.dto";
import { Company } from "src/modules/company/entities/company.entity";


import { Role } from "src/modules/users/entities/role.entity";

export class CreateUserDto extends AuthDto {
  @ApiProperty()
  @IsNotEmpty()
  fullName: string;


  @ApiProperty()
  @IsOptional()
  @IsEmail({}, { message: "Adresse e-mail invalide" })
  email: string;

  @ApiProperty()
  @IsNotEmpty()
  phoneNumber: string;

  @ApiProperty()
  @IsNotEmpty()
  countryCode: string;

  @ApiProperty()
  @IsOptional()
  password: string;



company:Company

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
