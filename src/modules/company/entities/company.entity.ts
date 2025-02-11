import { CreationEntity } from "src/common/entities/creation.entity";
import { Region } from "src/modules/region/entities/region.entity";
import { User } from "src/modules/users/entities/user.entity";
import { Column, Entity, JoinColumn, ManyToOne, OneToMany, OneToOne } from "typeorm";
import { Event } from "../../events/entities/event.entity";
@Entity()
export class Company extends CreationEntity {
  @Column()
  name: string;

  @Column({ nullable: true })
  imagePath: string;

@ManyToOne(()=>Region,(region)=>region.companies)
region :Region
  @Column({ nullable: true })
  whatsappPhoneNumber: string;
  @OneToOne(()=>User,user=>user.company)
 @JoinColumn()
  supervisor:User;
@OneToMany(()=>Event,(event)=>event.company)
events:Event[]
}
