import { User } from "src/modules/users/entities/user.entity";
import { Column, CreateDateColumn, DeleteDateColumn, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class NotificationToken {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  token: string;

  @ManyToOne((type) => User)
  user: User;

  @CreateDateColumn()
  createdAt: Date;

  @DeleteDateColumn()
  public deletedAt: Date;
}
