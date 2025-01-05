import { Injectable } from "@nestjs/common";

@Injectable()
export class LanguageDetectionService {
  isArabic(text: string): boolean {
    const arabicPattern = /[\u0600-\u06FF\u0750-\u077F]/;

    if (arabicPattern.test(text)) {
      return true;
    }
    return false;
  }

  isFrench(text: string): boolean {
    const frenchPattern = /[àâçéèêëîïôûùüÿñ]/i;

    if (frenchPattern.test(text)) {
      return true;
    }
    return false;
  }

  convertTextDirection(text) {
    if (this.isArabic(text)) {
      return text.split(" ").reverse().join(" ") + " ";
    }
    return text;
  }
}
