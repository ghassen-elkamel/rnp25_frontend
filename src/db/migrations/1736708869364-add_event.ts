import { MigrationInterface, QueryRunner } from "typeorm";

export class AddEvent1736708869364 implements MigrationInterface {
    name = 'AddEvent1736708869364'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "company" ADD "supervisorId" int`);
        await queryRunner.query(`CREATE UNIQUE INDEX "REL_7d926cc484e970dbd488a4953f" ON "company" ("supervisorId") WHERE "supervisorId" IS NOT NULL`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "FK_7d926cc484e970dbd488a4953f6" FOREIGN KEY ("supervisorId") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "FK_7d926cc484e970dbd488a4953f6"`);
        await queryRunner.query(`DROP INDEX "REL_7d926cc484e970dbd488a4953f" ON "company"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "supervisorId"`);
    }

}
