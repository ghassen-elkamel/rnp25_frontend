import { CreationEntity } from "src/common/entities/creation.entity";
import { FormQuestion } from "src/modules/form-question/entities/form-question.entity";
import { FormResponse } from "src/modules/form_response/entities/form_response.entity";
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Form  {
  @Column()
  title: string;

  @Column({ nullable: true })
  description: string;

  @Column({ default: true })
  isActive: boolean;

  @OneToMany(() => FormQuestion, (question) => question.form, { cascade: true })
  questions: FormQuestion[];

  @OneToMany(() => FormResponse, (response) => response.form)
  responses: FormResponse[];
}
