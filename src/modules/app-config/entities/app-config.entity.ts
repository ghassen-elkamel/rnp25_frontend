import { AbstractEntity } from "src/common/entities/abstract.entity";
import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from "typeorm";

@Entity()
export class AppConfig {
  @PrimaryGeneratedColumn()
  code: number;

  @Column({ nullable: true })
  playStoreUrl: string;

  @Column({ nullable: true })
  appleStoreUrl: string;

  @Column()
  minVersionAndroid: string;

  @Column()
  minVersionIOS: string;

  @Column()
  isDev: boolean;

  @CreateDateColumn()
  creationDate: Date;
}
