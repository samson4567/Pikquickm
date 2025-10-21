// domain/entities/wallet_summary_entity.dart
import 'package:equatable/equatable.dart';

class TaskMessageEntity extends Equatable {
  final String? id;
  final String? taskAssignmentId;
  final String? senderId;
  final String? senderRole;
  final String? message;
  final String? originalMessage;

  final List? attachments;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? readBy;
  final int? isEdited;

  const TaskMessageEntity({
    required this.id,
    this.taskAssignmentId,
    this.senderId,
    this.senderRole,
    this.message,
    this.originalMessage,
    this.attachments,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.readBy,
    this.isEdited,
  });

  @override
  List<Object?> get props => [
        id,
        taskAssignmentId,
        senderId,
        senderRole,
        message,
        originalMessage,
        attachments,
        status,
        createdAt,
        updatedAt,
        readBy,
        isEdited,
      ];
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