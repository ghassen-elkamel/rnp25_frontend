import { MigrationInterface, QueryRunner } from "typeorm";

export class Regions2691567957905 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`INSERT INTO region (id, name, nameSecondary, nameThird, countryId) VALUES 
       (1, N'تونس', N'Tunis', N'Tunus', 1),
    (2, N'أريانة', N'Ariana', N'Ariana', 1),
    (3, N'بن عروس', N'Ben Arous', N'Ben Arous', 1),
    (4, N'منوبة', N'Manouba', N'Manouba', 1),
    (5, N'نابل', N'Nabeul', N'Nabeul', 1),
    (6, N'زغوان', N'Zaghouan', N'Zaghouan', 1),
    (7, N'بنزرت', N'Bizerte', N'Bizerte', 1),
    (8, N'باجة', N'Beja', N'Beja', 1),
    (9, N'جندوبة', N'Jendouba', N'Jendouba', 1),
    (10, N'الكاف', N'Le Kef', N'Le Kef', 1),
    (11, N'سليانة', N'Siliana', N'Siliana', 1),
    (12, N'القيروان', N'Kairouan', N'Kairouan', 1),
    (13, N'القصرين', N'Kasserine', N'Kasserine', 1),
    (14, N'سيدي بوزيد', N'Sidi Bouzid', N'Sidi Bouzid', 1),
    (15, N'سوسة', N'Sousse', N'Sousse', 1),
    (16, N'المنستير', N'Monastir', N'Monastir', 1),
    (17, N'المهدية', N'Mahdia', N'Mahdia', 1),
    (18, N'صفاقس', N'Sfax', N'Sfax', 1),
    (19, N'قفصة', N'Gafsa', N'Gafsa', 1),
    (20, N'توزر', N'Tozeur', N'Tozeur', 1),
    (21, N'قبلي', N'Kebili', N'Kebili', 1),
    (22, N'قابس', N'Gabes', N'Gabes', 1),
    (23, N'مدنين', N'Medenine', N'Medenine', 1),
    (24, N'تطاوين', N'Tataouine', N'Tataouine', 1),
    (25, N'البطنان', N'Al Butnan', N'Al Butnan', 1),
    (26, N'درنة', N'Darnah', N'Darnah', 1),
    (27, N'الجبل الاخضر', N'Al Jabal al Akhdar', N'Al Jabal al Akhdar', 1),
    (28, N'المرج', N'Al Marj', N'Al Marj', 1),
    (29, N'بنغازي', N'Banghazi', N'Banghazi', 1),
    (30, N'الواحات', N'Al Wahat', N'Al Wahat', 1),
    (31, N'الكفرة', N'Al Kufrah', N'Al Kufrah', 1),
    (32, N'سرت', N'Surt', N'Surt', 1),
    (33, N'مصراتة', N'Misrata', N'Misrata', 1),
    (34, N'المرقب', N'Marqab', N'Marqab', 1),
    (35, N'طرابلس', N'Tarabulus', N'Tarabulus', 1),
    (36, N'الجفارة', N'Al Jafarah', N'Al Jafarah', 1),
    (37, N'الزاوية', N'Az Zawiyah', N'Az Zawiyah', 1),
    (38, N'النقاط الخمس', N'An Nuqat al Khams', N'An Nuqat al Khams', 1),
    (39, N'الجبل الغربي', N'Al Jabal al Gharbi', N'Al Jabal al Gharbi', 1),
    (40, N'نالوت', N'Nalut', N'Nalut', 1),
    (41, N'وادي الشاطئ', N'Wadi ash Shati', N'Wadi ash Shati', 1),
    (42, N'الجفرة', N'Al Jufrah', N'Al Jufrah', 1),
    (43, N'سبها', N'Sabha', N'Sabha', 1),
    (44, N'وادي الحياة', N'Wadi al Hayat', N'Wadi al Hayat', 1),
    (45, N'غات', N'Ghat', N'Ghat', 1),
    (46, N'مرزق', N'Murzuq', N'Murzuq', 1)
    ;`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE \`region\``);
  }
}
