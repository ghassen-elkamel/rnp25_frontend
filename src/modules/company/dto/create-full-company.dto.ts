import { CreationEntityDto } from "src/common/dto/creation.dto";

export class CreateFullCompanyDto extends CreationEntityDto {
  companyName: string;
  branchName: string;
  branchPosition: string;
  branchRegionId: number;
  username: string;
  firstName: string;
  lastName: string;
  phoneNumber: string;
  countryCode: string;
}
