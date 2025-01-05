import { MigrationInterface, QueryRunner } from "typeorm";

export class Init1730708058022 implements MigrationInterface {
    name = 'Init1730708058022'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "tracer" ("id" int NOT NULL IDENTITY(1,1), "createdAt" datetime2 NOT NULL CONSTRAINT "DF_56c41f7e9a73cc64b25975fd985" DEFAULT getdate(), "updatedAt" datetime2 NOT NULL CONSTRAINT "DF_b4eb3d14f3a395961df9de09811" DEFAULT getdate(), "createdBy" int, "url" text, "method" text, "name" text, "body" text, "query" text, "params" text, CONSTRAINT "PK_0dd56918b688c99095029ed298a" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "role" ("code" nvarchar(255) NOT NULL, "label" nvarchar(30) NOT NULL, CONSTRAINT "PK_ee999bb389d7ac0fd967172c41f" PRIMARY KEY ("code"))`);
        await queryRunner.query(`CREATE TABLE "company" ("id" int NOT NULL IDENTITY(1,1), "createdAt" datetime2 NOT NULL CONSTRAINT "DF_dbd45d4f25e03ce493fcbc551d6" DEFAULT getdate(), "updatedAt" datetime2 NOT NULL CONSTRAINT "DF_a0014ec13facc282bb2595128e7" DEFAULT getdate(), "createdBy" int, "name" nvarchar(255) NOT NULL, "imagePath" nvarchar(255), "isMultiCoffer" bit NOT NULL CONSTRAINT "DF_9f4f8f0dab3a8f3a72d2e99fbc1" DEFAULT 1, "isMultiBalanceClient" bit NOT NULL CONSTRAINT "DF_9de8916513fbbc67d2e02b6c2e1" DEFAULT 1, "haveDealers" bit NOT NULL CONSTRAINT "DF_623562b399503ac7fec73171183" DEFAULT 1, "haveCashiers" bit NOT NULL CONSTRAINT "DF_2b15393c05a3245f874466a081a" DEFAULT 1, "withSwiftDetails" bit NOT NULL CONSTRAINT "DF_be0b16e6986e5a2da07e2b80621" DEFAULT 1, "showCurrentExchangeRate" bit NOT NULL CONSTRAINT "DF_26b02a84226127d688921410d6f" DEFAULT 1, "showInternationalExchangeRate" bit NOT NULL CONSTRAINT "DF_6c344b52bb46cd92f91b96d7fb4" DEFAULT 0, "canChargePrincipalSafe" bit NOT NULL CONSTRAINT "DF_b37a5a63e49babed2d3f33e1047" DEFAULT 1, "whatsappPhoneNumber" nvarchar(255), CONSTRAINT "PK_056f7854a7afdba7cbd6d45fc20" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "country" ("id" int NOT NULL, "name" nvarchar(100) NOT NULL, "nameSecondary" nvarchar(100) NOT NULL, "nameThird" nvarchar(100) NOT NULL, "countryCode" nvarchar(100) NOT NULL, "phoneCountryCode" nvarchar(100), CONSTRAINT "PK_bf6e37c231c4f4ea56dcd887269" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "region" ("id" int NOT NULL, "name" nvarchar(100) NOT NULL, "nameSecondary" nvarchar(100) NOT NULL, "nameThird" nvarchar(100) NOT NULL, "countryId" int NOT NULL, CONSTRAINT "PK_5f48ffc3af96bc486f5f3f3a6da" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "branch" ("id" int NOT NULL IDENTITY(1,1), "createdAt" datetime2 NOT NULL CONSTRAINT "DF_d3a79d1a357d0daf87a35071953" DEFAULT getdate(), "updatedAt" datetime2 NOT NULL CONSTRAINT "DF_40d7fbf5928a3bba7e533fa6e5b" DEFAULT getdate(), "createdBy" int, "name" nvarchar(255), "position" nvarchar(255), "haveUserAccounts" bit NOT NULL CONSTRAINT "DF_2dcaa7123f947c467b522ff205f" DEFAULT 1, "deletedAt" datetime2, "regionId" int, "companyId" int, CONSTRAINT "PK_2e39f426e2faefdaa93c5961976" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "user" ("id" int NOT NULL IDENTITY(1,1), "createdAt" datetime2 NOT NULL CONSTRAINT "DF_e11e649824a45d8ed01d597fd93" DEFAULT getdate(), "updatedAt" datetime2 NOT NULL CONSTRAINT "DF_80ca6e6ef65fb9ef34ea8c90f42" DEFAULT getdate(), "externalCode" nvarchar(30) NOT NULL CONSTRAINT "DF_7a5d3f7dfdb4298660184edc408" DEFAULT '', "username" nvarchar(30) NOT NULL, "password" nvarchar(255) NOT NULL, "email" nvarchar(255), "firstName" nvarchar(255) NOT NULL, "lastName" nvarchar(255) NOT NULL, "phoneNumber" nvarchar(255) NOT NULL, "countryCode" nvarchar(255) NOT NULL, "pathPicture" nvarchar(255), "isVerified" bit NOT NULL, "isActive" bit NOT NULL, "isBlocked" bit NOT NULL, "language" nvarchar(255) NOT NULL CONSTRAINT "DF_44e3d73b0a8324670f0fc1f57e1" DEFAULT 'en', "deletedAt" datetime2, "role" nvarchar(255), "branchId" int, CONSTRAINT "UQ_78a916df40e02a9deb1c4b75edb" UNIQUE ("username"), CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "notification_token" ("id" int NOT NULL IDENTITY(1,1), "token" nvarchar(255) NOT NULL, "createdAt" datetime2 NOT NULL CONSTRAINT "DF_d268c7ee9e44f5d595deaa77c98" DEFAULT getdate(), "deletedAt" datetime2, "userId" int, CONSTRAINT "PK_99cf05a96c3aaf7dfd10b5740d0" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "notification_entity" ("key" nvarchar(255) NOT NULL, "title" nvarchar(255) NOT NULL CONSTRAINT "DF_fbbe4815c2800f2287b3af7a592" DEFAULT '', "titleSecondary" nvarchar(255) NOT NULL CONSTRAINT "DF_3dfde1be3603b94e69140cbf6c7" DEFAULT '', "titleThird" nvarchar(255) NOT NULL CONSTRAINT "DF_98cb286256af23cb7f123078c01" DEFAULT '', "body" nvarchar(255) NOT NULL CONSTRAINT "DF_53c742c32dbc6fc0e520c9b39a3" DEFAULT '', "bodySecondary" nvarchar(255) NOT NULL CONSTRAINT "DF_1a8403fbe001b76fe11e2f069ff" DEFAULT '', "bodyThird" nvarchar(255) NOT NULL CONSTRAINT "DF_6a64a7c0f3e9e83e55cc81b3654" DEFAULT '', CONSTRAINT "PK_2abb6027bd9a2edb2c036ba744d" PRIMARY KEY ("key"))`);
        await queryRunner.query(`CREATE TABLE "notification" ("id" int NOT NULL IDENTITY(1,1), "createdAt" datetime2 NOT NULL CONSTRAINT "DF_b11a5e627c41d4dc3170f1d3703" DEFAULT getdate(), "updatedAt" datetime2 NOT NULL CONSTRAINT "DF_489f2762db84e32ef4d1df3533a" DEFAULT getdate(), "title" nvarchar(255) NOT NULL, "body" nvarchar(255) NOT NULL, "key" nvarchar(255) NOT NULL, "isViewed" bit NOT NULL CONSTRAINT "DF_0c84b1f3141dff9bd70ac732ea1" DEFAULT 0, "senderId" int, "receiverId" int, CONSTRAINT "PK_705b6c7cdf9b2c2ff7ac7872cb7" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "app_config" ("code" int NOT NULL IDENTITY(1,1), "playStoreUrl" nvarchar(255), "appleStoreUrl" nvarchar(255), "minVersionAndroid" nvarchar(255) NOT NULL, "minVersionIOS" nvarchar(255) NOT NULL, "isDev" bit NOT NULL, "creationDate" datetime2 NOT NULL CONSTRAINT "DF_d44c7c03e08c56fc8c3f0d19ef8" DEFAULT getdate(), CONSTRAINT "PK_03047b760dd18405b19a9f5e89b" PRIMARY KEY ("code"))`);
        await queryRunner.query(`ALTER TABLE "region" ADD CONSTRAINT "FK_75ceb9efda6c228a50d88dcdfb8" FOREIGN KEY ("countryId") REFERENCES "country"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "branch" ADD CONSTRAINT "FK_fcdbc273e840a3b61a8d2932c76" FOREIGN KEY ("regionId") REFERENCES "region"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "branch" ADD CONSTRAINT "FK_d916e8de3e93fdf6bd13c734237" FOREIGN KEY ("companyId") REFERENCES "company"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user" ADD CONSTRAINT "FK_6620cd026ee2b231beac7cfe578" FOREIGN KEY ("role") REFERENCES "role"("code") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user" ADD CONSTRAINT "FK_8b17d5d91bf27d0a33fb80ade8f" FOREIGN KEY ("branchId") REFERENCES "branch"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "notification_token" ADD CONSTRAINT "FK_8c1dede7ba7256bff4e6155093c" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "notification" ADD CONSTRAINT "FK_c0af34102c13c654955a0c5078b" FOREIGN KEY ("senderId") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "notification" ADD CONSTRAINT "FK_758d70a0e61243171e785989070" FOREIGN KEY ("receiverId") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "notification" DROP CONSTRAINT "FK_758d70a0e61243171e785989070"`);
        await queryRunner.query(`ALTER TABLE "notification" DROP CONSTRAINT "FK_c0af34102c13c654955a0c5078b"`);
        await queryRunner.query(`ALTER TABLE "notification_token" DROP CONSTRAINT "FK_8c1dede7ba7256bff4e6155093c"`);
        await queryRunner.query(`ALTER TABLE "user" DROP CONSTRAINT "FK_8b17d5d91bf27d0a33fb80ade8f"`);
        await queryRunner.query(`ALTER TABLE "user" DROP CONSTRAINT "FK_6620cd026ee2b231beac7cfe578"`);
        await queryRunner.query(`ALTER TABLE "branch" DROP CONSTRAINT "FK_d916e8de3e93fdf6bd13c734237"`);
        await queryRunner.query(`ALTER TABLE "branch" DROP CONSTRAINT "FK_fcdbc273e840a3b61a8d2932c76"`);
        await queryRunner.query(`ALTER TABLE "region" DROP CONSTRAINT "FK_75ceb9efda6c228a50d88dcdfb8"`);
        await queryRunner.query(`DROP TABLE "app_config"`);
        await queryRunner.query(`DROP TABLE "notification"`);
        await queryRunner.query(`DROP TABLE "notification_entity"`);
        await queryRunner.query(`DROP TABLE "notification_token"`);
        await queryRunner.query(`DROP TABLE "user"`);
        await queryRunner.query(`DROP TABLE "branch"`);
        await queryRunner.query(`DROP TABLE "region"`);
        await queryRunner.query(`DROP TABLE "country"`);
        await queryRunner.query(`DROP TABLE "company"`);
        await queryRunner.query(`DROP TABLE "role"`);
        await queryRunner.query(`DROP TABLE "tracer"`);
    }

}
