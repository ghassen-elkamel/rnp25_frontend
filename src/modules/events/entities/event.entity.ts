import { CreationEntity } from "src/common/entities/creation.entity";
import { Company } from "src/modules/company/entities/company.entity";
import { Column, Entity, JoinColumn, ManyToOne } from "typeorm";
@Entity()
export class Event extends CreationEntity{
    @Column()
    title: string;
    @Column()
    description: string;
    @Column()
    startDate: Date
    @Column()
    endDate: Date
    @Column({
        nullable:true
    })
    location: string;
    @Column({nullable:true})
    pathPicture :string
    @ManyToOne(()=>Company,(company=>company.events))
    @JoinColumn()
    company:Company


    

}
