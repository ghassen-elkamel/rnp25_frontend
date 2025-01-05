import { ApiProperty } from "@nestjs/swagger";
import { IsEmpty, IsNotEmpty } from "class-validator";
import { User } from "src/modules/users/entities/user.entity";

export class CreateNotificationDto {
  @ApiProperty()
  @IsNotEmpty()
  title: string;

  @ApiProperty()
  @IsNotEmpty()
  body: string;

  @ApiProperty()
  @IsNotEmpty()
  key: string;

  @ApiProperty()
  sender: User;

  @ApiProperty()
  receiver: User;

  @ApiProperty()
  @IsNotEmpty()
  createdAt: Date;

  @ApiProperty()
  @IsEmpty()
  viewed: boolean;

  constructor({ title, body, key, sender, receiver }) {
    this.title = title;
    this.body = body;
    this.key = key;
    this.sender = sender;
    this.receiver = receiver;
    this.viewed = false;
  }
}
