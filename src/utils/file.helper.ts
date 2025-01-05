import { v1 as uuidv1 } from "uuid";

export class FileHelper {
  static customFileName(req, file, cb) {
    const uniqueSuffix = uuidv1();
    let fileExtension = file.originalname.split(".").pop();
    if (file.originalname.indexOf(".") < 0) {
      fileExtension = "png";
    }

    cb(null, uniqueSuffix + "." + fileExtension);
  }
}
