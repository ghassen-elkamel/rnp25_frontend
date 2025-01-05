import { CreationEntityDto } from "src/common/dto/creation.dto";
import { Company } from "src/modules/company/entities/company.entity";
import { Region } from "src/modules/region/entities/region.entity";

export class CreateBranchDto extends CreationEntityDto {
  name: string;

  position: string;

  regionId: number;
  region: Region;

  companyId: number;
  company: Company;
}
