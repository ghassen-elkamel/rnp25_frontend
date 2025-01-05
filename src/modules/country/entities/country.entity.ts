import { Entity, PrimaryColumn, Column } from "typeorm";

@Entity()
export class Country {
  @PrimaryColumn()
  public id: number;

  @Column({ length: 100 })
  name: string;

  @Column({ length: 100 })
  nameSecondary: string;

  @Column({ length: 100 })
  nameThird: string;

  @Column({ length: 100 })
  countryCode: string;

  @Column({ length: 100, nullable: true })
  phoneCountryCode: string;
}
