import { PipeTransform, Injectable, ArgumentMetadata, BadRequestException } from "@nestjs/common";

@Injectable()
export class FilesTypeValidationPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    value.forEach((item) => {
      fileTypeValidation(item);
    });
    return value;
  }
}

@Injectable()
export class FileTypeValidationPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    return fileTypeValidation(value);
  }
}

export function fileTypeValidation(value: any) {
  if (value) {
    const authorizedExtension = ["DOC", "DOCX", "JPEG", "JPG", "PNG", "PDF"];

    const fileExtension = value.originalname.split(".").pop().toUpperCase();
    const isSupported = authorizedExtension.includes(fileExtension);
    if (!isSupported && fileExtension.indexOf(".") > 0) {
      throw new BadRequestException(
        `Invalid Input Data Format. ${fileExtension} is not included in this list [${authorizedExtension}]`,
      );
    }
  }
  return value;
}
