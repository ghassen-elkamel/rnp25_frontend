import { AbstractEntity } from "src/common/entities/abstract.entity";
import { User } from "src/modules/users/entities/user.entity";
import { Column, JoinColumn, ManyToOne } from "typeorm";
import { Entity } from "typeorm/decorator/entity/Entity";

@Entity()
export class Notification extends AbstractEntity {
  @Column()
  title: string;

  @Column()
  body: string;

  @Column()
  key: string;

  @ManyToOne(() => User, { nullable: true })
  @JoinColumn()
  sender: User;

  @ManyToOne(() => User, { nullable: true })
  @JoinColumn()
  receiver: User;

  @Column({ default: false })
  isViewed: boolean;
}
