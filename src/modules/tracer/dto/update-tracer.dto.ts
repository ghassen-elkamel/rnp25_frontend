import { PartialType } from "@nestjs/swagger";
import { CreateTracerDto } from "./create-tracer.dto";

export class UpdateTracerDto extends PartialType(CreateTracerDto) {}
