import { AppConfig } from "src/modules/app-config/entities/app-config.entity";
import { MigrationInterface, QueryRunner } from "typeorm";

export class AppConfig2688189763794 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    const item1 = await queryRunner.manager.save(
      queryRunner.manager.create(AppConfig, {
        minVersionAndroid: "1.0.0",
        minVersionIOS: "1.0.0",
        isDev: false,
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DELETE * FROM ${AppConfig.name}`);
  }
}
