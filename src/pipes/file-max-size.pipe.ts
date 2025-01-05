import { PipeTransform, Injectable, ArgumentMetadata, BadRequestException } from "@nestjs/common";

@Injectable()
export class FilesSizeValidationPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    value.forEach((item) => {
      fileSizeValidation(item);
    });
    return value;
  }
}

@Injectable()
export class FileSizeValidationPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    return fileSizeValidation(value);
  }
}

export function fileSizeValidation(value: any) {
  if (value) {
    const oneMo = 1024 * 1024;
    const maxFileSize = 5 * oneMo;

    if (value.size > maxFileSize) {
      throw new BadRequestException(
        "Invalid Input Data Size " +
          (value.size / oneMo).toFixed(3) +
          " Mo / " +
          (maxFileSize / oneMo).toFixed(0) +
          " Mo",
      );
    }
  }

  return value;
}
