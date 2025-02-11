import { QuestionType } from "src/enums/question-type.enum";
import { Form } from "src/modules/form/entities/form.entity";
import { QuestionResponse } from "src/modules/question_response/entities/question_response.entity";
import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class FormQuestion {
   @PrimaryGeneratedColumn('uuid')
   id: string;

  @Column()
  question: string;

  @Column({
    type: 'simple-enum',
    enum: QuestionType,
    default: QuestionType.TEXT
  })
  type: QuestionType;

  @Column({
    type: 'nvarchar',
    length: 'max',
    nullable: true,
    transformer: {
      to(value: string[] | null): string | null {
        return value ? JSON.stringify(value) : null;
      },
      from(value: string | null): string[] | null {
        return value ? JSON.parse(value) : null;
      }
    }
  })
  options: string[];

  @Column({ default: false })
  isRequired: boolean;

  @Column({ type: 'int', default: 0 })
  order: number;

  @ManyToOne(() => Form, form => form.questions, { onDelete: 'CASCADE' })
  form: Form;

  @OneToMany(() => QuestionResponse, response => response.question)
  responses: QuestionResponse[];
}
