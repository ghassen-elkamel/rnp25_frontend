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
import { In, IsNull, Not, Repository } from "typeorm";
import { CreateUserDto } from "./dto/create-user.dto";
import { User } from "./entities/user.entity";
import { Order } from "src/enums/order.enum";
import { v1 as uuidv1 } from "uuid";
import { UpdateUserDto } from "./dto/update-user.dto";
import { NotificationsService } from "../notifications/notifications.service";
import { NotificationTokenService } from "../notification-token/notification-token.service";
import { CreateNotificationTokenDto } from "../notification-token/dto/create-notification-token.dto";

import { NotificationType } from "src/enums/notification.enum";
import { Role } from "./entities/role.entity";

import { use } from "passport";

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,

    private notificationTokenService: NotificationTokenService,
    @Inject(forwardRef(() => NotificationsService))
    private notificationsService: NotificationsService,
  ) {}

  async create(createUserDto: CreateUserDto) {
    const user = await this.finOneByEmail(createUserDto.phoneNumber);
    if (user) {
      if (user.deletedAt) {
        await this.usersRepository.restore({ id: user.id });
        await this.addTokenToUser(createUserDto.fcmToken, user);
        return user;
      } else {
        throw new BadRequestException("thisUsernameAlreadyExistsPleaseTryAgain");
      }
    }



    createUserDto.isActive = true;
    createUserDto.isVerified = true;
    createUserDto.isBlocked = false;
    createUserDto.role = new Role(RolesType.client);

    let key1 = uuidv1();
    let password = key1.split("-")[0];
    let returnPassword = false;
    if (!createUserDto.password) {
      returnPassword = true;
      createUserDto.password = await encodePassword(password);
    } else {
      createUserDto.password = await encodePassword(createUserDto.password);
    }

    const newUser = await this.usersRepository.create(createUserDto);
    await this.usersRepository.save(newUser);

    delete newUser.role;
    if (returnPassword) {
      newUser.password = password;
    }
    await this.addTokenToUser(createUserDto.fcmToken, newUser);
    return newUser;
  }

  async findOneByPhone(phoneNumber: string, countryCode: string) {
    const user = await this.usersRepository.findOne({
      where: {
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      },
      relations: {
        notificationToken: true,
        role: true,

    
      },
      select: {
        id: true,
        phoneNumber: true,
        countryCode: true,
        password: true,
        fullName: true,
        language: true,
        role: {
          code: true,
          label: true,
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

      },
    });

    if (!user) throw new NotFoundException("User does not exist");

    return user;
  }

  async update(user: UpdateUserDto) {
    const oldItem = await this.usersRepository.findOne({
      where: { id: user.id },
      relations: {  role: true },
    });

    if (!oldItem) {
      throw new UnauthorizedException();
    }

    const verifyUser = await this.findOneByPhone(user.phoneNumber, user.countryCode);
    if (verifyUser && verifyUser.id != oldItem.id) {
      throw new BadRequestException("thisUsernameAlreadyExistsPleaseTryAgain");
    }



    return this.usersRepository.save(user);
  }

  async findAllByRole(args: { roles: RolesType[]; companyId: number }) {
    const users = await this.usersRepository.find({
      where: {
   
        role: {
          code: In(args.roles),
        },
      },
      relations: {
       
        role: true,
      },
      order: {
        createdAt: Order.DESC,
      },
    });

    return users;
  }

  async deleteUser(userId: number) {
    const user = await this.usersRepository.findOne({ where: { id: userId },  });
    const result = await this.usersRepository.softDelete({
      id: userId,
    });

    if (result.affected > 0) {
      const numberOfUsers = await this.usersRepository.count({
        where: {
   
        },
      });

    }

    return result;
  }

  async countByRole(rolesType: RolesType, branchId: number, companyId: number): Promise<number> {


    return await this.usersRepository.count({
      where: {
        role: {
          code: rolesType,
        },

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
    let roles = [RolesType.admin];
    const users = await this.usersRepository.find({
      where: {

        role: {
          code: In(roles),
        },
      },
      relations: {
        role: true,

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

  findByIds(usersId: number[]) {
    return this.usersRepository.find({
      where: {
        id: In(usersId),
      },
    });
  }

  async saveChanges(user: User) {
    return await this.usersRepository.save(user);
  }
 async  finOneByEmail(email: string) {
    const user = await this.usersRepository.findOne({
      where: {

email:email
      },
      relations: {
        notificationToken: true,
        role: true,
        company :true

     
      },
      select: {
        id: true,
        phoneNumber: true,
        countryCode: true,
        password: true,
        fullName: true,
        language: true,
        role: {
          code: true,
          label: true,
        },
     
        isBlocked: true,
        deletedAt: true,
        isVerified: true,
      },
      withDeleted: true,
    });
    return user;
  }
}
