import { CreationEntity } from "src/common/entities/creation.entity";
import { Column, Entity } from "typeorm";

@Entity()
export class Company extends CreationEntity {
  @Column()
  name: string;

  @Column({ nullable: true })
  imagePath: string;

  @Column({ default: true })
  isMultiCoffer: boolean;

  @Column({ default: true })
  isMultiBalanceClient: boolean;

  @Column({ default: true })
  haveDealers: boolean;

  @Column({ default: true })
  haveCashiers: boolean;

  @Column({ default: true })
  withSwiftDetails: boolean;

  @Column({ default: true })
  showCurrentExchangeRate: boolean;

  @Column({ default: false })
  showInternationalExchangeRate: boolean;

  @Column({ default: true })
  canChargePrincipalSafe: boolean;

  @Column({ nullable: true })
  whatsappPhoneNumber: string;
}
