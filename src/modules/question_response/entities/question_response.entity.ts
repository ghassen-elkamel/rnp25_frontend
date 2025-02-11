
import { Transform } from 'class-transformer';
import { CreationEntity } from 'src/common/entities/creation.entity';
import { QuestionType } from 'src/enums/question-type.enum';
import { FormQuestion } from 'src/modules/form-question/entities/form-question.entity';
import { FormResponse } from 'src/modules/form_response/entities/form_response.entity';
import { Column, Entity, ManyToOne } from 'typeorm';

@Entity('question_responses')
export class QuestionResponse extends CreationEntity{


  @ManyToOne(() => FormQuestion, question => question.responses)
  question: FormQuestion;

  @ManyToOne(() => FormResponse, response => response.responses)
  formResponse: FormResponse;

  @Column({ type: 'nvarchar', length: 'max' })
  @Transform(({ value, obj }) => {
    const question = obj.question;
    if (!question) return value;

    let transformedValue;
    switch (question.type) {
      case QuestionType.TEXT:
      case QuestionType.LONG_TEXT:
      case QuestionType.EMAIL:
      case QuestionType.PHONE:
        transformedValue = { value: String(value?.value || '') };
        break;
      case QuestionType.NUMBER:
        transformedValue = { value: Number(value?.value || 0) };
        break;
      case QuestionType.CHECKBOX:
        transformedValue = { value: Boolean(value?.value || false) };
        break;
      case QuestionType.DATE:
      case QuestionType.TIME:
        transformedValue = { value: value?.value ? new Date(value.value) : null };
        break;
      case QuestionType.RADIO:
      case QuestionType.SELECT:
        transformedValue = { value: String(value?.value || '') };
        break;
      case QuestionType.MULTIPLE_SELECT:
        transformedValue = { value: Array.isArray(value?.value) ? value.value : [] };
        break;
      default:
        transformedValue = value;
    }
    return JSON.stringify(transformedValue);
  })
  value: string; 

  getValue(): {
    value: string | number | boolean | Date | string[];
    meta?: Record<string, any>;
  } {
    try {
      return JSON.parse(this.value);
    } catch {
      return { value: null };
    }
  }

  validate(): string[] {
    const errors: string[] = [];

    if (!this.question) {
      errors.push('Question is required');
      return errors;
    }

    const value = this.getValue();

    if (this.question.isRequired && !value.value) {
      errors.push('This field is required');
    }

    try {
      switch (this.question.type) {
        case QuestionType.EMAIL:
          if (value.value && !this.isValidEmail(String(value.value))) {
            errors.push('Invalid email format');
          }
          break;

        case QuestionType.PHONE:
          if (value.value && !this.isValidPhone(String(value.value))) {
            errors.push('Invalid phone number format');
          }
          break;

        case QuestionType.NUMBER:
          if (value.value && !this.isValidNumber(value.value)) {
            errors.push('Invalid number format');
          }
          break;

        case QuestionType.SELECT:
        case QuestionType.RADIO:
          if (value.value && !this.isValidOption(String(value.value))) {
            errors.push('Invalid option selected');
          }
          break;

        case QuestionType.MULTIPLE_SELECT:
          if (value.value && !this.isValidMultipleOptions(value.value as string[])) {
            errors.push('Invalid options selected');
          }
          break;
      }
    } catch (error) {
      errors.push('Validation error occurred');
    }

    return errors;
  }

  private isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  private isValidPhone(phone: string): boolean {
    return /^\+?[\d\s-]{8,}$/.test(phone);
  }

  private isValidNumber(value: any): boolean {
    return !isNaN(Number(value));
  }

  private isValidOption(value: string): boolean {
    return this.question.options?.includes(value) ?? false;
  }

  private isValidMultipleOptions(values: string[]): boolean {
    return values.every(value => this.question.options?.includes(value));
  }
}