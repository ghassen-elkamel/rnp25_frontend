import { applyDecorators, UseInterceptors } from "@nestjs/common";
import { FileInterceptor, FilesInterceptor } from "@nestjs/platform-express";
import { ApiConsumes } from "@nestjs/swagger";
import { diskStorage } from "multer";
import { FileHelper } from "src/utils/file.helper";

export function ApiFile(dir: string) {
  return applyDecorators(
    ApiConsumes("multipart/form-data"),
    UseInterceptors(
      FileInterceptor("files", {
        storage: diskStorage({
          destination: "./" + dir,
          filename: FileHelper.customFileName,
        }),
      }),
    ),
  );
}
export function ApiFiles(dir: string) {
  return applyDecorators(
    ApiConsumes("multipart/form-data"),
    UseInterceptors(
      FilesInterceptor("files", 10, {
        storage: diskStorage({
          destination: "./" + dir,
          filename: FileHelper.customFileName,
        }),
      }),
    ),
  );
}
