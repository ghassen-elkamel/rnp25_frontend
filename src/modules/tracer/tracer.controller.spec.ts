import { Test, TestingModule } from "@nestjs/testing";
import { TracerController } from "./tracer.controller";
import { TracerService } from "./tracer.service";

describe("TracerController", () => {
  let controller: TracerController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TracerController],
      providers: [TracerService],
    }).compile();

    controller = module.get<TracerController>(TracerController);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });
});
