import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty } from "class-validator";

export class CreateAppConfigDto {
  @ApiProperty()
  @IsNotEmpty()
  playStoreUrl: string;

  @ApiProperty()
  @IsNotEmpty()
  appleStoreUrl: string;

  @ApiProperty()
  @IsNotEmpty()
  minVersionAndroid: string;

  @ApiProperty()
  @IsNotEmpty()
  minVersionIOS: string;

  @ApiProperty()
  @IsNotEmpty()
  isDev: boolean;

  constructor({ minVersionAndroid, minVersionIOS }) {
    this.minVersionAndroid = minVersionAndroid;
    this.minVersionIOS = minVersionIOS;
  }
}
