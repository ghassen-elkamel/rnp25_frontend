import { CreationEntityDto } from "src/common/dto/creation.dto";

export class CreateCompanyDto extends CreationEntityDto {
  name: string;
  imagePath: string;
}
