import { AbstractEntity } from "src/common/entities/abstract.entity";
import { CreationEntity } from "src/common/entities/creation.entity";
import { Column, Entity } from "typeorm";

@Entity()
export class Tracer extends CreationEntity {
  @Column({ nullable: true, type: "text" })
  url: string;
  @Column({ nullable: true, type: "text" })
  method: string;
  @Column({ nullable: true, type: "text" })
  name: string;
  @Column({ nullable: true, type: "text" })
  body: string;
  @Column({ nullable: true, type: "text" })
  query: string;
  @Column({ nullable: true, type: "text" })
  params: string;
}
