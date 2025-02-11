import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateUser1736607843342 implements MigrationInterface {
    name = 'UpdateUser1736607843342'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" DROP CONSTRAINT "DF_7a5d3f7dfdb4298660184edc408"`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "externalCode"`);
        await queryRunner.query(`ALTER TABLE "user" DROP CONSTRAINT "UQ_78a916df40e02a9deb1c4b75edb"`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "username"`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "firstName"`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "lastName"`);
        await queryRunner.query(`ALTER TABLE "user" ADD "fullName" nvarchar(255) NOT NULL CONSTRAINT "DF_035190f70c9aff0ef331258d28b" DEFAULT ''`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" DROP CONSTRAINT "DF_035190f70c9aff0ef331258d28b"`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "fullName"`);
        await queryRunner.query(`ALTER TABLE "user" ADD "lastName" nvarchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE "user" ADD "firstName" nvarchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE "user" ADD "username" nvarchar(30) NOT NULL`);
        await queryRunner.query(`ALTER TABLE "user" ADD CONSTRAINT "UQ_78a916df40e02a9deb1c4b75edb" UNIQUE ("username")`);
        await queryRunner.query(`ALTER TABLE "user" ADD "externalCode" nvarchar(30) NOT NULL`);
        await queryRunner.query(`ALTER TABLE "user" ADD CONSTRAINT "DF_7a5d3f7dfdb4298660184edc408" DEFAULT '' FOR "externalCode"`);
    }

}
