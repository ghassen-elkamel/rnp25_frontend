import { forwardRef, Inject, Injectable } from "@nestjs/common";
import * as firebase from "firebase-admin";
import * as firebaseCredentialsProd from "../../firebase/google-fcm-dev.json";
import * as firebaseCredentialsDev from "../../firebase/google-fcm-dev.json";
import { ServiceAccount } from "firebase-admin";
import { UsersService } from "../users/users.service";
import { NotificationEntity } from "./entities/notification-model.entity";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { GlobalNotificationMessage } from "./entities/notification-message.entity";
import { NotificationType } from "src/enums/notification.enum";
import { CreateNotificationDto } from "./dto/create-notification.dto";
import { Notification } from "./entities/notification.entity";
import { User } from "../users/entities/user.entity";
import { PageOptionsDto } from "src/common/dto/page-options.dto";
import { PageMetaDto } from "src/common/dto/page-meta.dto";
import { PageDto } from "src/common/dto/page.dto";
import { Order } from "src/enums/order.enum";

@Injectable()
export class NotificationsService {
  private appDev: firebase.app.App;
  private appProd: firebase.app.App;

  constructor(
    @InjectRepository(NotificationEntity)
    private notificationModelsRepository: Repository<NotificationEntity>,
    @InjectRepository(Notification)
    private notificationsRepository: Repository<Notification>,
    @Inject(forwardRef(() => UsersService))
    private usersService: UsersService,
  ) {
    // this.appDev = firebase.initializeApp(
    //   {
    //     credential: firebase.credential.cert(firebaseCredentialsDev as ServiceAccount),
    //   },
    //   "dev",
    // );
    // this.appProd = firebase.initializeApp(
    //   {
    //     credential: firebase.credential.cert(firebaseCredentialsProd as ServiceAccount),
    //   },
    //   "prod",
    // );
  }

  async findOneByKey(key: NotificationType): Promise<NotificationEntity> {
    const notification = await this.notificationModelsRepository.findOne({
      where: {
        key: key,
      },
    });
    return notification;
  }

  async findOneByType(type: NotificationType) {
    const notification = await this.notificationModelsRepository.findOne({
      where: {
        key: type,
      },
    });
    return notification;
  }

  async createMessage(args: {
    token: string;
    receiverId: number;
    senderId?: number;
    key: NotificationType;
    me: string;
    client: string;
    employee: string;
    data?: {};
  }) {
    let notification = await this.findOneByKey(args.key);
    let language = await this.usersService.getLanguage(args.receiverId);
    let title: string = notification.title;
    let body: string = notification.body;

    switch (language) {
      case "en":
        title = notification.titleSecondary;
        body = notification.bodySecondary;
        break;
      case "tr":
        title = notification.titleThird;
        body = notification.bodyThird;
        break;
    }

    body = body.replace("$me", args.me);
    body = body.replace("$client", args.client);
    body = body.replace("$employee", args.employee);

    args.data = { ...args.data, key: args.key };

    let message = {
      receiverId: args.receiverId,
      senderId: args.senderId,
      content: {
        token: args.token,
        notification: {
          title: title,
          body: body,
        },
        data: args.data,
        android: {
          notification: {
            sound: "notification.wav",
          },
        },
      },
    };

    return message;
  }

  async sendMessages(messages: GlobalNotificationMessage[]) {
    console.log("***INFO[Notifications]***");

    console.log(messages);

    if (messages.length > 0) {
      let pushMessages = [];
      let notificationMessages: CreateNotificationDto[] = [];

      messages.forEach(async (m) => {
        pushMessages.push(m.content);

        const notification = new CreateNotificationDto({
          sender: m.senderId,
          receiver: m.receiverId,
          body: m.content.notification.body,
          title: m.content.notification.title,
          key: m.content.data.key,
        });
        notificationMessages.push(notification);
      });

      try {
        await this.notificationsRepository.save(notificationMessages);
      } catch (e) {
        console.log(e);
      }

      try {
        // if (process.env.APP_ENV == 'dev') {
        //   await this.appDev.messaging().sendEach(pushMessages);
        // } else {
        //   await this.appProd.messaging().sendEach(pushMessages);
        // }
        await this.appDev.messaging().sendEach(pushMessages);
      } catch (e) {
        console.log(e);
      }

      return { response: "Notification sent successfully" };
    }
    return { response: "No notification to sent" };
  }

  public async sendToClient(args: {
    receiverId: number;
    key: NotificationType;
    client: string;
    employee: string;
    senderId?: number;
  }) {
    let receiver: User = await this.usersService.findOneWithNotificationTokens(args.receiverId);

    let messages = [];

    for (const notificationToken of receiver.notificationToken) {
      let message = await this.createMessage({
        token: notificationToken.token,
        receiverId: args.receiverId,
        senderId: args.senderId,
        key: args.key,
        me: "",
        client: args.client,
        employee: args.employee,
      });
      messages.push(message);
    }
    return this.sendMessages(messages);
  }

  public async sendToEmployee(args: {
    receiverId: number;
    key: NotificationType;
    clientName: string;
    employeeName: string;
    senderId?: number;
  }) {
    let employee: User = await this.usersService.findOneWithNotificationTokens(args.receiverId);

    let messages = [];

    for (const notificationToken of employee.notificationToken) {
      let message = await this.createMessage({
        token: notificationToken.token,
        receiverId: args.receiverId,
        key: args.key,
        me: "",
        client: args.clientName,
        employee: args.employeeName,
        senderId: args.senderId,
      });
      messages.push(message);
    }
    return this.sendMessages(messages);
  }

  public async sendToManyUsers(args: { branchId: number; key: NotificationType; senderId?: number }) {
    let users: User[] = await this.usersService.findUsersByBranchId(args.branchId);

    let messages = [];

    for (const user of users) {
      for (const notificationToken of user.notificationToken) {
        let message = await this.createMessage({
          token: notificationToken.token,

          senderId: args.senderId,
          receiverId: user.id,
          key: args.key,
          me: "",
          client: "",
          employee: "",
        });
        messages.push(message);
      }
    }
    return this.sendMessages(messages);
  }

  async findMyNotifications(args: { pageOptionsDto: PageOptionsDto; userId }) {
    let filter = {
      where: {
        receiver: {
          id: args.userId,
        },
      },
    };
    const itemCount = await this.notificationsRepository.count({
      ...filter,
    });
    const notifications = await this.notificationsRepository.find({
      ...filter,
      order: { createdAt: Order.DESC },
      skip: args.pageOptionsDto.skip,
      take: args.pageOptionsDto.take,
    });

    const pageMetaDto = new PageMetaDto({
      itemCount,
      pageOptionsDto: args.pageOptionsDto,
    });
    return new PageDto(notifications, pageMetaDto);
  }

  async viewNotification(idNotification: number) {
    const notification = await this.notificationsRepository.findOne({
      where: {
        id: idNotification,
      },
    });
    notification.isViewed = true;
    this.notificationsRepository.save(notification);
    return notification;
  }
}
