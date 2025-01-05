import { PipeTransform, Injectable, ArgumentMetadata, BadRequestException } from "@nestjs/common";

@Injectable()
export class FileImageValidationPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    if (value) {
      const imageExtension = ["JPEG", "JPG", "PNG", "GIF", "TIFF", "RAW"];

      const fileExtension = value.originalname.split(".").pop().toUpperCase();
      const isSupported = imageExtension.includes(fileExtension);
      if (!isSupported) {
        throw new BadRequestException(
          `Invalid Input Data Format. ${fileExtension} is not included in this list [${imageExtension}]`,
        );
      }
    }
    return value;
  }
}
