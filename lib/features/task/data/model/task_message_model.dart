// domain/entities/wallet_summary_entity.dart

import 'package:pikquick/features/task/domain/entitties/task_message_entity.dart';

// TaskMessageEntity
class TaskMessageModel extends TaskMessageEntity {
  const TaskMessageModel({
    required super.id,
    required super.taskAssignmentId,
    required super.senderId,
    required super.senderRole,
    required super.message,
    required super.originalMessage,
    required super.attachments,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.readBy,
    required super.isEdited,
  });
  factory TaskMessageModel.fromJson(Map<String, dynamic> json) {
    print("dshsjdhksjhdj${json}");
    // taskId: json['task_id'] as String? ?? '',
    return TaskMessageModel(
      id: json['id'],
      taskAssignmentId: json['task_assignment_id'],
      senderId: json['sender_id'],
      senderRole: json['sender_role'],
      message: json['message'],
      originalMessage: json['original_message'],
      attachments: json['attachments'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      readBy: json['read_by'],
      isEdited: json['is_edited'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_assignment_id': taskAssignmentId,
      'sender_id': senderId,
      'sender_role': senderRole,
      'message': message,
      'original_message': originalMessage,
      'attachments': attachments,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'read_by': readBy,
      'is_edited': isEdited,
    };
  }

  factory TaskMessageModel.fromEntity(TaskMessageEntity taskMessageEntity) {
    // taskId: json['task_id'] as String? ?? '',
    return TaskMessageModel(
      id: taskMessageEntity.id,
      taskAssignmentId: taskMessageEntity.taskAssignmentId,
      senderId: taskMessageEntity.senderId,
      senderRole: taskMessageEntity.senderRole,
      message: taskMessageEntity.message,
      originalMessage: taskMessageEntity.originalMessage,
      attachments: taskMessageEntity.attachments,
      status: taskMessageEntity.status,
      createdAt: taskMessageEntity.createdAt,
      updatedAt: taskMessageEntity.updatedAt,
      readBy: taskMessageEntity.readBy,
      isEdited: taskMessageEntity.isEdited,
    );
  }
}


//  {
//             "id": "afa818a3-418c-48d1-a4f3-29313b574650",
//             "task_assignment_id": "8e55f314-9f6a-11f0-b251-00163cbf7aa3",
//             "sender_id": "933b013b-234e-4f8b-a15b-bd210d823f8b",
//             "sender_role": "client",
//             "message": "Hello! This is a test message from the API.",
//             "attachments": null,
//             "status": "sent",
//             "created_at": "2025-10-16T12:36:55.000Z",
//             "updated_at": "2025-10-16T12:36:55.000Z",
//             "read_by": null,
//             "is_edited": 0,
//             "original_message": null
//         }