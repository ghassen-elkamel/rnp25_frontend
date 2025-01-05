import { RolesType } from "src/enums/roles.enum";
import { Role } from "src/modules/users/entities/role.entity";
import { MigrationInterface, QueryRunner } from "typeorm";

export class userRoles2679652234239 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    const r1 = await queryRunner.manager.save(
      queryRunner.manager.create(Role, {
        code: RolesType.appManager,
        label: "app manager",
      }),
    );
    const r2 = await queryRunner.manager.save(
      queryRunner.manager.create(Role, {
        code: RolesType.admin,
        label: "admin",
      }),
    );
    const r3 = await queryRunner.manager.save(
      queryRunner.manager.create(Role, {
        code: RolesType.driver,
        label: "driver",
      }),
    );
    const r4 = await queryRunner.manager.save(
      queryRunner.manager.create(Role, {
        code: RolesType.client,
        label: "client",
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DELETE * FROM role`);
  }
}
