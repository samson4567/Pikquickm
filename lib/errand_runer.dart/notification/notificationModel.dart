import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';

class NotificationModel {
  final String? title;
  final String? body;
  final String? date;
  String? id;

  NotificationModel({
    required this.title,
    required this.body,
    required this.date,
    this.id,
  }) {
    id ??= Uuid().v4();
  }

  factory NotificationModel.fromJson({required Map json}) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      date: json['date'],
      id: json['Unique_ID'],
    );
  }
  NotificationModel copyWith({
    String? title,
    String? body,
    String? date,
  }) {
    return NotificationModel(
        title: title ?? this.title,
        body: body ?? this.body,
        date: date ?? this.date,
        id: this.id);
  }

  Map toMap() {
    return {
      "title": title,
      "body": body,
      "date": date,
      'Unique_ID': id,
    };
  }

  factory NotificationModel.fromRemoteNotificationObject(
      {required RemoteNotification notification,
      required RemoteMessage remoteMessage}) {
    return NotificationModel(
      title: notification.title,
      body: notification.body,
      date: (remoteMessage.sentTime == null)
          ? null
          : remoteMessage.sentTime.toString(),
      id: Uuid().v4(),
    );
  }

  factory NotificationModel.dummy() {
    return NotificationModel(
      title: "Onome Eritage",
      body: "body is bodying",
      date: DateTime.now().toString(),
    );
  }
}
