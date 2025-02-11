import { CreationEntityDto } from "src/common/dto/creation.dto";

export class CreateFullCompanyDto extends CreationEntityDto {
  companyName: string;
  regionId: number;
  username: string;
  fullName: string;
  email : string;
  phoneNumber: string;
  countryCode: string;
}
