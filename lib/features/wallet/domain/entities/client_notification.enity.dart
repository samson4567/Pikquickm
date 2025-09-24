import 'package:equatable/equatable.dart';

class ClientNotificationEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? type;
  final String? audience;
  final String? title;
  final String? message;
  final int? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? taskId;
  final String? relatedUserId;
  final String? taskStatus;

  const ClientNotificationEntity({
    this.id,
    this.userId,
    this.type,
    this.audience,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.taskId,
    this.relatedUserId,
    this.taskStatus,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        audience,
        title,
        message,
        isRead,
        createdAt,
        updatedAt,
        taskId,
        relatedUserId,
        taskStatus,
      ];
}
