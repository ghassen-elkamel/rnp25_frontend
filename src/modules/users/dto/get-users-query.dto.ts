import { Transform } from "class-transformer";
import { IsArray, IsEnum } from "class-validator";
import { RolesType } from "src/enums/roles.enum";

export class GetUsersQueryDto {
  @Transform(({ value }) => value.split(","))
  @IsArray()
  @IsEnum(RolesType, { each: true })
  roles: RolesType[];
}
