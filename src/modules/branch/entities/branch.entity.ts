import { CreationEntity } from "src/common/entities/creation.entity";
import { Company } from "src/modules/company/entities/company.entity";
import { Region } from "src/modules/region/entities/region.entity";
import { User } from "src/modules/users/entities/user.entity";
import { Column, DeleteDateColumn, Entity, JoinColumn, ManyToOne, OneToMany } from "typeorm";

@Entity()
export class Branch extends CreationEntity {
  @Column({ nullable: true })
  name: string;

  @Column({ nullable: true })
  position: string;

  @ManyToOne((type) => Region)
  @JoinColumn()
  region: Region;

  @ManyToOne((type) => Company)
  @JoinColumn()
  company: Company;

  @OneToMany(() => User, (e) => e.branch)
  users: User[];

  @Column({ default: true })
  haveUserAccounts: boolean;

  @DeleteDateColumn()
  deletedAt: Date;
}
