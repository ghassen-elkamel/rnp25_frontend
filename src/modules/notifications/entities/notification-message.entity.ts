import { TokenMessage } from "firebase-admin/lib/messaging/messaging-api";

export interface NotificationMessage extends TokenMessage {}

export interface GlobalNotificationMessage {
  receiverId: number;
  senderId: number;
  content: NotificationMessage;
}
