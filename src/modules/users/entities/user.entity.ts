import { AbstractEntity } from "src/common/entities/abstract.entity";
import { Role } from "src/modules/users/entities/role.entity";
import { Column, DeleteDateColumn, Entity, JoinColumn, ManyToOne, OneToMany } from "typeorm";
import { Branch } from "src/modules/branch/entities/branch.entity";
import { NotificationToken } from "src/modules/notification-token/entities/notification-token.entity";

@Entity()
export class User extends AbstractEntity {
  @ManyToOne((type) => Role)
  @JoinColumn({ name: "role" })
  role: Role;

  @Column({ length: 30, default: "" })
  externalCode: string;

  @Column({ length: 30, unique: true })
  username: string;

  @Column({ select: false })
  password: string;

  @Column({ nullable: true })
  email: string;

  @Column()
  firstName: string;

  @Column()
  lastName: string;

  @Column()
  phoneNumber: string;

  @Column()
  countryCode: string;

  @Column({ nullable: true })
  pathPicture: string;

  @ManyToOne((type) => Branch, { nullable: true })
  @JoinColumn()
  branch: Branch;

  @Column()
  isVerified: boolean;

  @Column()
  isActive: boolean;

  @Column()
  isBlocked: boolean;

  @OneToMany((type) => NotificationToken, (notificationToken) => notificationToken.user)
  notificationToken: NotificationToken[];

  @Column({ default: "en" })
  language: string;

  @DeleteDateColumn()
  deletedAt: Date;

  get fullName(): string {
    return this.firstName + " " + this.lastName + " " + this.externalCode ?? "";
  }

  constructor(userId?: number) {
    super();
    this.id = userId;
  }
  public toString(): string {
    return this.firstName + " " + this.lastName + " " + this.externalCode ?? "";
  }
}
