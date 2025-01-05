import { Column } from "typeorm";
import { AbstractEntity } from "./abstract.entity";

export abstract class CreationEntity extends AbstractEntity {
  @Column({ nullable: true })
  createdBy: number;
}
