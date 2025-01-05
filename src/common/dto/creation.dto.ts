import { ApiProperty } from "@nestjs/swagger";

export abstract class AbstractEntityDto {
  createdAt: Date;
  timestamp: Date;
}
export abstract class CreationEntityDto extends AbstractEntityDto {
  @ApiProperty()
  createdBy: number;
  constructor(user?: string) {
    super();
    this.setCreationInfo(user);
  }

  setCreationInfo(user?: string) {
    if (user) {
      this.createdBy = +user;
    }
    this.createdAt = new Date();
    this.timestamp = new Date();
  }
}
