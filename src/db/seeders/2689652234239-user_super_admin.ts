import { last } from "rxjs";
import { RolesType } from "src/enums/roles.enum";
import { Role } from "src/modules/users/entities/role.entity";
import { User } from "src/modules/users/entities/user.entity";
import { MigrationInterface, QueryRunner } from "typeorm";

export class userSuperAdmin2689652234239 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    const admin = await queryRunner.manager.save(
      queryRunner.manager.create(User, {
        firstName: "admin",
        lastName: "admin",
        email: "admin@gmail.com",
        username: "admin",
        countryCode: "216",
        phoneNumber: "22222222",
        isActive: true,
        isBlocked: false,
        isVerified: true,
        role: new Role(RolesType.appManager),
        password: "$2a$10$PpCH6BhjKjKyhFJPCx.H2.RsZkpacm4da07QB.Igs55i8qFKXxnEi",
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DELETE * FROM role`);
  }
}
