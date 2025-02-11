import { MigrationInterface, QueryRunner } from "typeorm";

export class AddEvent1736708684445 implements MigrationInterface {
    name = 'AddEvent1736708684445'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "event" ("id" int NOT NULL IDENTITY(1,1), "createdAt" datetime2 NOT NULL CONSTRAINT "DF_77b45e61f3194ba2be468b07789" DEFAULT getdate(), "updatedAt" datetime2 NOT NULL CONSTRAINT "DF_d88128dae17a09fe1327fe550d3" DEFAULT getdate(), "createdBy" int, "title" nvarchar(255) NOT NULL, "description" nvarchar(255) NOT NULL, "startDate" datetime NOT NULL, "endDate" datetime NOT NULL, "location" nvarchar(255), "pathPicture" nvarchar(255), CONSTRAINT "PK_30c2f3bbaf6d34a55f8ae6e4614" PRIMARY KEY ("id"))`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE "event"`);
    }

}
