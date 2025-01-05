import { Global, Module } from "@nestjs/common";
import { TracerService } from "./tracer.service";
import { TracerController } from "./tracer.controller";
import { Tracer } from "./entities/tracer.entity";
import { TypeOrmModule } from "@nestjs/typeorm";

@Global()
@Module({
  imports: [TypeOrmModule.forFeature([Tracer])],
  controllers: [TracerController],
  providers: [TracerService],
  exports: [TracerService],
})
export class TracerModule {}
