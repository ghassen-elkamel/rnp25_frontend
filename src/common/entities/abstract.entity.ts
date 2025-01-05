import { Exclude } from "class-transformer";
import { PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from "typeorm";
import * as moment from "moment";

export abstract class AbstractEntity {
  @PrimaryGeneratedColumn()
  public id: number;

  @CreateDateColumn()
  public createdAt: Date;

  getCreationDate(): string {
    return moment(this.createdAt).format("DD/MM/YY");
  }

  @UpdateDateColumn()
  public updatedAt: Date;
}
