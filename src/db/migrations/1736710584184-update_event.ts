import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateEvent1736710584184 implements MigrationInterface {
    name = 'UpdateEvent1736710584184'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "event" ADD "companyId" int`);
        await queryRunner.query(`ALTER TABLE "event" ADD CONSTRAINT "FK_62d4aa390c2a2a7856d358ce72f" FOREIGN KEY ("companyId") REFERENCES "company"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "event" DROP CONSTRAINT "FK_62d4aa390c2a2a7856d358ce72f"`);
        await queryRunner.query(`ALTER TABLE "event" DROP COLUMN "companyId"`);
    }

}
