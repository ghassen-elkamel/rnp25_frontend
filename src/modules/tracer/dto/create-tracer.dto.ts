import { ApiProperty } from "@nestjs/swagger";

export class CreateTracerDto {
  @ApiProperty()
  url: string;

  @ApiProperty()
  method: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  body: string;

  @ApiProperty()
  query: string;

  @ApiProperty()
  params: string;
}
