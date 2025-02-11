import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty } from "class-validator";
import { CreationEntityDto } from "src/common/dto/creation.dto";
import { Company } from "src/modules/company/entities/company.entity";

export class CreateEventDto extends CreationEntityDto {
    @ApiProperty()
    @IsNotEmpty()
    title:string
    @ApiProperty()
    @IsNotEmpty()
    description:string
    @ApiProperty()
    @IsNotEmpty()
    startDate:Date
    @ApiProperty()
    endDate:Date
    @ApiProperty()
    pathPicture
    @ApiProperty()
    location :string
    company :Company
    


}
