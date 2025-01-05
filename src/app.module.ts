import { Module, Global } from "@nestjs/common";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { UsersModule } from "./modules/users/users.module";
import { AuthModule } from "./modules/auth/auth.module";
import { TypeOrmModule } from "@nestjs/typeorm";
import { dataSourceOptions } from "./db/data-source";
import { ScheduleModule } from "@nestjs/schedule";
import { APP_INTERCEPTOR } from "@nestjs/core";
import { TracingInterceptor } from "./interceptors/tracing.interceptor";
import { RegionModule } from "./modules/region/region.module";
import { CountryModule } from "./modules/country/country.module";
import { TracerModule } from "./modules/tracer/tracer.module";
import { AppConfigModule } from "./modules/app-config/app-config.module";
import { NotificationsModule } from "./modules/notifications/notifications.module";
import { NotificationTokenModule } from "./modules/notification-token/notification-token.module";
import { CompanyModule } from "./modules/company/company.module";
import { BranchModule } from "./modules/branch/branch.module";
import * as path from "path";
import { AcceptLanguageResolver, HeaderResolver, I18nModule, QueryResolver } from "nestjs-i18n";
@Global()
@Module({
  imports: [
    I18nModule.forRootAsync({
      useFactory: () => ({
        fallbackLanguage: "en",
        loaderOptions: {
          path: path.join(__dirname, "/i18n/"),
          watch: true,
        },
      }),
      resolvers: [{ use: QueryResolver, options: ["lang"] }, AcceptLanguageResolver, new HeaderResolver(["x-lang"])],
    }),
    TypeOrmModule.forRoot(dataSourceOptions),
    ScheduleModule.forRoot(),
    UsersModule,
    AuthModule,
    RegionModule,
    CountryModule,
    TracerModule,
    AppConfigModule,
    NotificationsModule,
    NotificationTokenModule,
    CompanyModule,
    BranchModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_INTERCEPTOR,
      useClass: TracingInterceptor,
    },
  ],
})
export class AppModule {}
