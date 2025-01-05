import {
  BadRequestException,
  forwardRef,
  Inject,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { RolesType } from "src/enums/roles.enum";
import { encodePassword } from "src/utils/bycrpt.helper";
import { In, Repository } from "typeorm";
import { CreateUserDto } from "./dto/create-user.dto";
import { User } from "./entities/user.entity";
import { Order } from "src/enums/order.enum";
import { v1 as uuidv1 } from "uuid";
import { UpdateUserDto } from "./dto/update-user.dto";
import { NotificationsService } from "../notifications/notifications.service";
import { NotificationTokenService } from "../notification-token/notification-token.service";
import { CreateNotificationTokenDto } from "../notification-token/dto/create-notification-token.dto";
import { BranchService } from "../branch/branch.service";
import { CreateBranchDto } from "../branch/dto/create-branch.dto";
import { Company } from "../company/entities/company.entity";
import { NotificationType } from "src/enums/notification.enum";

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
    private branchService: BranchService,
    private notificationTokenService: NotificationTokenService,
    @Inject(forwardRef(() => NotificationsService))
    private notificationsService: NotificationsService,
  ) {}

  async create(createUserDto: CreateUserDto, companyId?: number) {
    const user = await this.findOneByUsername(createUserDto.username);
    if (user) {
      if (user.deletedAt) {
        await this.usersRepository.restore({ id: user.id });
        await this.addTokenToUser(createUserDto.fcmToken, user);
        return user;
      } else {
        throw new BadRequestException("thisUsernameAlreadyExistsPleaseTryAgain");
      }
    }

    if (!createUserDto.branch && createUserDto.branchId) {
      createUserDto.branch = await this.branchService.findOne(createUserDto.branchId);
    }

    createUserDto.isActive = true;
    createUserDto.isVerified = true;
    createUserDto.isBlocked = false;
    let key1 = uuidv1();
    let password = key1.split("-")[0];

    createUserDto.password = await encodePassword(password);

    const newUser = await this.usersRepository.create(createUserDto);
    await this.usersRepository.save(newUser);

    delete newUser.role;
    newUser.password = password;
    newUser.username = createUserDto.username;
    await this.addTokenToUser(createUserDto.fcmToken, newUser);
    return newUser;
  }

  async findOneByUsername(username: string) {
    const user = await this.usersRepository.findOne({
      where: {
        username: username,
      },
      relations: {
        notificationToken: true,
        role: true,
        branch: {
          company: true,
        },
      },
      select: {
        id: true,
        username: true,
        password: true,
        firstName: true,
        lastName: true,
        language: true,
        role: {
          code: true,
          label: true,
        },
        branch: {
          id: true,
          company: {
            id: true,
          },
        },
        isBlocked: true,
        deletedAt: true,
        isVerified: true,
      },
      withDeleted: true,
    });
    return user;
  }

  async findOne(id: number) {
    if (!id) {
      return;
    }
    const user = await this.usersRepository.findOne({
      where: {
        id: id,
      },
      relations: {
        role: true,
      },
    });

    if (!user) throw new NotFoundException("User does not exist");

    return user;
  }

  async findOneWihtBranch(id: number) {
    if (!id) {
      return;
    }
    const user = await this.usersRepository.findOne({
      where: {
        id: id,
      },
      relations: {
        branch: true,
        role: true,
      },
    });

    if (!user) throw new NotFoundException("User does not exist");

    return user;
  }
  async findOneWihtCompany(id: number) {
    if (!id) {
      return;
    }
    const user = await this.usersRepository.findOne({
      where: {
        id: id,
      },
      relations: {
        branch: {
          company: true,
        },
      },
    });

    if (!user) throw new NotFoundException("User does not exist");

    return user;
  }

  async findOneWithFullBranch(id: number) {
    const user = await this.usersRepository.findOne({
      where: {
        id: id,
      },
      relations: {
        role: true,
        branch: true,
      },
    });

    if (!user) throw new NotFoundException("User does not exist");

    return user;
  }

  async update(user: UpdateUserDto, companyId: number) {
    const oldItem = await this.usersRepository.findOne({
      where: { id: user.id, branch: { company: { id: companyId } } },
      relations: { branch: true, role: true },
    });

    if (!oldItem) {
      throw new UnauthorizedException();
    }

    if (user.externalCode != oldItem.externalCode) {
      if (oldItem.role.code == RolesType.client) {
        user.username = user.branchId.toString().padStart(3, "0") + user.externalCode;
      }
      const verifyUser = await this.findOneByUsername(user.username);
      if (verifyUser && verifyUser.id != oldItem.id) {
        throw new BadRequestException("thisUsernameAlreadyExistsPleaseTryAgain");
      }
    }
    if (user.branchId && user.branchId != oldItem.branch.id) {
      user.branch = await this.branchService.findOne(user.branchId);
    } else {
      user.branch = oldItem.branch;
    }

    if (user.branch.name != user.firstName) {
      user.branch.name = user.firstName;
      this.branchService.update(user.branch);
      user.lastName = "";
    }
    return this.usersRepository.save(user);
  }

  async findAllByRole(args: { roles: RolesType[]; companyId: number }) {
    const users = await this.usersRepository.find({
      where: {
        role: {
          code: In(args.roles),
        },
        branch: {
          company: {
            id: args.companyId,
          },
        },
      },
      relations: {
        branch: { region: { country: true } },
        role: true,
      },
      order: {
        createdAt: Order.DESC,
      },
    });

    return users;
  }

  async deleteUser(userId: number) {
    const user = await this.usersRepository.findOne({ where: { id: userId }, relations: { branch: true } });
    const result = await this.usersRepository.softDelete({
      id: userId,
    });

    if (result.affected > 0) {
      const numberOfUsers = await this.usersRepository.count({
        where: {
          branch: {
            id: user.branch.id,
          },
        },
      });
      if (numberOfUsers == 0) {
        await this.branchService.deleteBranch(user.branch.id);
      }
    }

    return result;
  }

  async countByRole(rolesType: RolesType, branchId: number, companyId: number): Promise<number> {
    let branchCondition = {};
    if (branchId) {
      branchCondition = {
        branch: {
          id: branchId,
        },
      };
    }

    if (companyId) {
      branchCondition = {
        branch: {
          company: {
            id: companyId,
          },
        },
      };
    }

    return await this.usersRepository.count({
      where: {
        role: {
          code: rolesType,
        },
        ...branchCondition,
      },
    });
  }

  async setProfilePhoto(userId: number, file: Express.Multer.File) {
    let user: User = await this.findOne(userId);

    if (!user) {
      throw new NotFoundException("user not found");
    }
    user.pathPicture = file.filename;

    return await this.usersRepository.save(user);
  }

  async addTokenToUser(fcmToken, user) {
    if (fcmToken) {
      this.notificationTokenService.addNotificationToken(
        new CreateNotificationTokenDto({
          user: user,
          token: fcmToken,
        }),
      );
      let message = await this.notificationsService.createMessage({
        token: fcmToken,
        receiverId: user.id,
        key: NotificationType.welcome,
        me: user.firstName + " " + user.lastName,
        client: "",
        employee: "",
      });

      this.notificationsService.sendMessages([message]);
    }
  }

  async findOneWithNotificationTokens(id: number) {
    const user = await this.usersRepository.findOne({
      where: {
        id: id,
      },
      relations: {
        notificationToken: true,
      },
    });
    return user;
  }

  async findUsersByBranchId(branchId: number) {
    let roles = [RolesType.admin, RolesType.driver];
    const users = await this.usersRepository.find({
      where: {
        branch: {
          id: branchId,
        },
        role: {
          code: In(roles),
        },
      },
      relations: {
        role: true,
        branch: true,
        notificationToken: true,
      },
    });

    if (!users) throw new NotFoundException("Users does not exist");

    return users;
  }

  async getLanguage(userId: number) {
    const user = await this.usersRepository.findOne({
      where: {
        id: userId,
      },
      select: {
        language: true,
      },
    });

    if (!user) throw new NotFoundException("User does not exist");

    return user.language;
  }

  async setLanguage(userId: number, language: string) {
    let user: User = await this.findOne(userId);

    if (!user) {
      throw new NotFoundException("user not found");
    }
    user.language = language;

    return await this.usersRepository.save(user);
  }

  async updatePassword(id: number, newPassword: string) {
    let user = await this.findOne(id);
    user.password = await encodePassword(newPassword);

    return await this.usersRepository.save(user);
  }
}
