import { CreationEntity } from 'src/common/entities/creation.entity';
import { Form } from 'src/modules/form/entities/form.entity';
import { QuestionResponse } from 'src/modules/question_response/entities/question_response.entity';
import { User } from 'src/modules/users/entities/user.entity';
import { Entity, PrimaryGeneratedColumn, ManyToOne, OneToMany, CreateDateColumn } from 'typeorm';


@Entity('form_responses')
export class FormResponse extends CreationEntity{

  @ManyToOne(() => Form, form => form.responses)
  form: Form;

  @ManyToOne(() => User, user => user.formResponses)
  user: User;

  @OneToMany(() => QuestionResponse, response => response.formResponse, { cascade: true })
  responses: QuestionResponse[];

  @CreateDateColumn()
  submittedAt: Date;
}