import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateCompany1736699080573 implements MigrationInterface {
    name = 'UpdateCompany1736699080573'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" DROP CONSTRAINT "FK_8b17d5d91bf27d0a33fb80ade8f"`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "branchId"`);
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "DF_9f4f8f0dab3a8f3a72d2e99fbc1"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "isMultiCoffer"`);
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "DF_9de8916513fbbc67d2e02b6c2e1"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "isMultiBalanceClient"`);
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "DF_623562b399503ac7fec73171183"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "haveDealers"`);
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "DF_2b15393c05a3245f874466a081a"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "haveCashiers"`);
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "DF_be0b16e6986e5a2da07e2b80621"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "withSwiftDetails"`);
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "DF_26b02a84226127d688921410d6f"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "showCurrentExchangeRate"`);
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "DF_6c344b52bb46cd92f91b96d7fb4"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "showInternationalExchangeRate"`);
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "DF_b37a5a63e49babed2d3f33e1047"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "canChargePrincipalSafe"`);
        await queryRunner.query(`ALTER TABLE "company" ADD "regionId" int`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "FK_7a82450902ff289a5d95e523820" FOREIGN KEY ("regionId") REFERENCES "region"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "company" DROP CONSTRAINT "FK_7a82450902ff289a5d95e523820"`);
        await queryRunner.query(`ALTER TABLE "company" DROP COLUMN "regionId"`);
        await queryRunner.query(`ALTER TABLE "company" ADD "canChargePrincipalSafe" bit NOT NULL`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "DF_b37a5a63e49babed2d3f33e1047" DEFAULT 1 FOR "canChargePrincipalSafe"`);
        await queryRunner.query(`ALTER TABLE "company" ADD "showInternationalExchangeRate" bit NOT NULL`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "DF_6c344b52bb46cd92f91b96d7fb4" DEFAULT 0 FOR "showInternationalExchangeRate"`);
        await queryRunner.query(`ALTER TABLE "company" ADD "showCurrentExchangeRate" bit NOT NULL`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "DF_26b02a84226127d688921410d6f" DEFAULT 1 FOR "showCurrentExchangeRate"`);
        await queryRunner.query(`ALTER TABLE "company" ADD "withSwiftDetails" bit NOT NULL`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "DF_be0b16e6986e5a2da07e2b80621" DEFAULT 1 FOR "withSwiftDetails"`);
        await queryRunner.query(`ALTER TABLE "company" ADD "haveCashiers" bit NOT NULL`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "DF_2b15393c05a3245f874466a081a" DEFAULT 1 FOR "haveCashiers"`);
        await queryRunner.query(`ALTER TABLE "company" ADD "haveDealers" bit NOT NULL`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "DF_623562b399503ac7fec73171183" DEFAULT 1 FOR "haveDealers"`);
        await queryRunner.query(`ALTER TABLE "company" ADD "isMultiBalanceClient" bit NOT NULL`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "DF_9de8916513fbbc67d2e02b6c2e1" DEFAULT 1 FOR "isMultiBalanceClient"`);
        await queryRunner.query(`ALTER TABLE "company" ADD "isMultiCoffer" bit NOT NULL`);
        await queryRunner.query(`ALTER TABLE "company" ADD CONSTRAINT "DF_9f4f8f0dab3a8f3a72d2e99fbc1" DEFAULT 1 FOR "isMultiCoffer"`);
        await queryRunner.query(`ALTER TABLE "user" ADD "branchId" int`);
        await queryRunner.query(`ALTER TABLE "user" ADD CONSTRAINT "FK_8b17d5d91bf27d0a33fb80ade8f" FOREIGN KEY ("branchId") REFERENCES "branch"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

}
