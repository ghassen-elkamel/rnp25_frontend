import { Injectable } from "@nestjs/common";
import { v1 as uuidv1 } from "uuid";

@Injectable()
export class ImageService {
  download(res, buffer) {
    let file_name = "IMG" + uuidv1() + ".png";
    res.set({
      "Content-Type": "image/png",
      "Content-Disposition": `attachment; filename=${file_name}`,
      "Content-Length": buffer?.length,
    });
    res.end(buffer);
  }
}
