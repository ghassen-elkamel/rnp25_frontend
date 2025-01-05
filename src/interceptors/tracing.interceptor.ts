import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from "@nestjs/common";
import { Observable } from "rxjs";
import { tap } from "rxjs/operators";
import { CreateTracerDto } from "src/modules/tracer/dto/create-tracer.dto";
import { TracerService } from "src/modules/tracer/tracer.service";

@Injectable()
export class TracingInterceptor implements NestInterceptor {
  constructor(private readonly tracerService: TracerService) {}
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    let trace: CreateTracerDto = new CreateTracerDto();
    trace.url = context.getArgs()[0].url;
    trace.method = context.getArgs()[0].method;
    trace.name = context.getHandler().name;
    trace.body = JSON.stringify(context.getArgs()[0].body);
    trace.query = JSON.stringify(context.getArgs()[0].query);
    trace.params = JSON.stringify(context.getArgs()[0].params);
    this.tracerService.create(trace);
    return next.handle().pipe(tap(() => {}));
  }
}
