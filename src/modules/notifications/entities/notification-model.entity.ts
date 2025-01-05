import { NotificationType } from "src/enums/notification.enum";
import { Column, PrimaryColumn } from "typeorm";
import { Entity } from "typeorm/decorator/entity/Entity";

@Entity()
export class NotificationEntity {
  @PrimaryColumn()
  key: NotificationType;

  @Column({ default: "" })
  title: string;

  @Column({ default: "" })
  titleSecondary: string;

  @Column({ default: "" })
  titleThird: string;

  @Column({ default: "" })
  body: string;

  @Column({ default: "" })
  bodySecondary: string;

  @Column({ default: "" })
  bodyThird: string;
}
