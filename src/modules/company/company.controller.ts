import { Controller, Get, Post, Body, UseGuards, Req, UploadedFile, Res, Query } from "@nestjs/common";
import { CompanyService } from "./company.service";
import { ApiTags, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { CreateFullCompanyDto } from "./dto/create-full-company.dto";
import { ApiFile } from "../../decorators/api-file.decorator";
import { FileSizeValidationPipe } from "../../pipes/file-max-size.pipe";
import { FileTypeValidationPipe } from "../../pipes/file-type-validation.pipe";
import { Public } from "src/decorators/public.decorator";

@Controller("v1/company")
@ApiTags("company")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
export class CompanyController {
  constructor(private readonly companyService: CompanyService) {}

  @Post()
  @ApiFile(process.env.UPLOAD_DIR + process.env.UPLOAD_COMPANIES_DIR)
  create(
    @Body() createFullCompanyDto: CreateFullCompanyDto,
    @Req() req,
    @UploadedFile(FileSizeValidationPipe, FileTypeValidationPipe)
    file: Express.Multer.File,
  ) {
    let userId = req.user.userId;
    return this.companyService.create(createFullCompanyDto, userId, file);
  }

  @Get("company-photo")
  @Public()
  async getPhoto(@Res() res, @Query("path") path) {
    await res.sendFile(path, {
      root: process.env.UPLOAD_DIR + process.env.UPLOAD_COMPANIES_DIR,
    });
  }

  @Get("all")
  findAll() {
    return this.companyService.findAll();
  }

  @Get("current-company")
  findCurrentCompany(@Req() req) {
    const companyId = req.user.companyId;
    return this.companyService.findCurrentCompany(+companyId);
  }
}
