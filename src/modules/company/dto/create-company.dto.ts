import { CreationEntityDto } from "src/common/dto/creation.dto";
import { Region } from "src/modules/region/entities/region.entity";

export class CreateCompanyDto extends CreationEntityDto {
  name: string;
  imagePath: string;
  region:Region
}
