import 'package:pikquick/features/task/domain/entitties/complete_entites.dart';

class MarkAsCompletedModel extends MarkAsCompletedEntity {
  const MarkAsCompletedModel({
    required super.taskId,
  });

  factory MarkAsCompletedModel.fromJson(Map<String, dynamic> json) {
    return MarkAsCompletedModel(
      taskId: json['task_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
    };
  }
}
