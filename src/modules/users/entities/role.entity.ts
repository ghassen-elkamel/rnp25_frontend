import { RolesType } from "src/enums/roles.enum";
import { User } from "src/modules/users/entities/user.entity";
import { Column, Entity, OneToMany, PrimaryColumn } from "typeorm";

@Entity()
export class Role {
  @PrimaryColumn()
  code: RolesType;

  @Column({ length: 30 })
  label: string;

  @OneToMany(() => User, (user) => user.role)
  users: User[];

  constructor(code) {
    this.code = code;
  }
}
