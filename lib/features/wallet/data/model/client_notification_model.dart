import 'package:pikquick/features/wallet/domain/entities/client_notification.enity.dart';

class ClientNotificationModel extends ClientNotificationEntity {
  const ClientNotificationModel({
    super.id,
    super.userId,
    super.type,
    super.audience,
    super.title,
    super.message,
    super.isRead,
    super.createdAt,
    super.updatedAt,
    super.taskId,
    super.relatedUserId,
    super.taskStatus,
  });

  factory ClientNotificationModel.fromJson(Map<String, dynamic> json) {
    return ClientNotificationModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      type: json['type'] as String?,
      audience: json['audience'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      isRead: json['isRead'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      taskId: json['taskId'] as String?,
      relatedUserId: json['relatedUserId'] as String?,
      taskStatus: json['taskStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'audience': audience,
      'title': title,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'taskId': taskId,
      'relatedUserId': relatedUserId,
      'taskStatus': taskStatus,
    };
  }

  static List<ClientNotificationModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => ClientNotificationModel.fromJson(e)).toList();
  }
}
