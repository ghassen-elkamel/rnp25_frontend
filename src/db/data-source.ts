import { DataSource, DataSourceOptions } from "typeorm";
import * as dotenv from "dotenv";
dotenv.config();
export const dataSourceOptions: DataSourceOptions = {
  type: "mssql",
  host: process.env.DB_HOST,
  port: +process.env.DB_PORT,
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,

  entities: ["dist/**/*.entity.js"],
  logging: false,
  synchronize: false,
  migrations: ["dist/db/migrations/*", "dist/db/seeders/*"],
  migrationsTableName: "migrations",
  migrationsRun: true,
  options: {
    trustServerCertificate: true,
  },
  requestTimeout: 300000,
};

const dataSource = new DataSource(dataSourceOptions);
export default dataSource;
