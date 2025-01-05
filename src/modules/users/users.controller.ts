import {
  Controller,
  Get,
  Param,
  UseGuards,
  Req,
  Delete,
  Post,
  Body,
  BadRequestException,
  Query,
  Patch,
  UnauthorizedException,
  UploadedFile,
  Res,
  UseInterceptors,
} from "@nestjs/common";
import { UsersService } from "./users.service";
import { ApiBearerAuth, ApiTags } from "@nestjs/swagger";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { CreateUserDto } from "./dto/create-user.dto";
import { RolesType } from "src/enums/roles.enum";
import { Role } from "./entities/role.entity";
import { UpdateUserDto } from "./dto/update-user.dto";
import { ApiFile } from "src/decorators/api-file.decorator";
import { FileSizeValidationPipe } from "src/pipes/file-max-size.pipe";
import { FileTypeValidationPipe } from "src/pipes/file-type-validation.pipe";
import { Public } from "src/decorators/public.decorator";
import { FileInterceptor } from "@nestjs/platform-express";
import { GetUsersQueryDto } from "./dto/get-users-query.dto";

@ApiTags("Users")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("v1/users")
export class UsersController {
  constructor(private readonly usersService: UsersService) {}
  @Get()
  async findAll(@Query() query: GetUsersQueryDto, @Req() req) {
    let companyId: number = req.user.companyId;
    if (!query.roles) {
      query.roles = [];
    }

    let items = await this.usersService.findAllByRole({ roles: query.roles, companyId });
    return { items };
  }

  @Post()
  create(@Body() createUserDto: CreateUserDto, @Req() req) {
    let companyId = req.user.companyId;

    createUserDto.role = new Role(createUserDto.receivedRole);
    return this.usersService.create(createUserDto, companyId);
  }

  @Get("me")
  findMe(@Req() req, @Query("userId") userId: number) {
    if (!userId) {
      userId = req.user.userId;
    }
    return this.usersService.findOne(userId);
  }

  @Patch()
  update(@Req() req, @Body() user: UpdateUserDto) {
    let companyId = req.user.companyId;

    return this.usersService.update(user, companyId);
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.usersService.findOne(+id);
  }

  @Delete()
  deleteMyAccount(@Req() req) {
    let userId = req.user.userId;

    return this.usersService.deleteUser(+userId);
  }

  @Delete(":id")
  deleteUser(@Req() req, @Param("id") id: string) {
    let userRole = req.user.role;
    let canCreate = [RolesType.appManager, RolesType.admin].includes(userRole);
    if (!canCreate) {
      throw new BadRequestException("you can't do this action");
    }

    return this.usersService.deleteUser(+id);
  }

  @Post("profile/photo")
  @ApiFile(process.env.UPLOAD_DIR + process.env.UPLOAD_PROFILES_DIR)
  setProfilePhoto(
    @UploadedFile(FileSizeValidationPipe, FileTypeValidationPipe)
    file: Express.Multer.File,
    @Req() req,
  ) {
    let response = this.usersService.setProfilePhoto(req.user.userId, file);
    return response;
  }

  @Public()
  @Get("/uploads/profiles")
  getProfilePhoto(@Res() res, @Query("path") path) {
    res.sendFile(path, {
      root: process.env.UPLOAD_DIR + process.env.UPLOAD_PROFILES_DIR,
    });
  }

  @Patch("language")
  setLanguage(@Req() req, @Query("language") language) {
    let userId = req.user.userId;

    return this.usersService.setLanguage(userId, language);
  }

  @Patch("password/:id")
  updatePassword(@Param("id") id: string, @Body() body) {
    return this.usersService.updatePassword(+id, body.newPassword);
  }

  @Public()
  @Get("/public/image")
  getPhoto(@Res() res, @Query("ee") path, @Query("root") root) {
    const newPath = path.replace(process.env.ASSETS_DIR, "");
    res.sendFile(newPath, {
      root: root ?? process.env.ASSETS_DIR,
    });
  }
}
