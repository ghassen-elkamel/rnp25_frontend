import { ValidationPipe } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { AppModule } from "./app.module";
import { NestExpressApplication } from "@nestjs/platform-express";
import { join } from "path";

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    cors: true,
  });

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      validationError: {
        value: true,
        target: true,
      },
    }),
  );

  app.setGlobalPrefix("api");

  const config = new DocumentBuilder()
    .setTitle(process.env.APP_NAME)
    .setDescription("The " + process.env.APP_NAME + " API description")
    .setVersion("1.0")
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("swagger/api", app, document);

  app.setBaseViewsDir(join(__dirname, "..", "assets/templates"));
  app.useStaticAssets(join(__dirname, "..", ""));
  app.setViewEngine("ejs");

  await app.listen(process.env.PORT_OUT).then(() => console.log(`Running on ${process.env.PORT_OUT}`));
}
bootstrap();
