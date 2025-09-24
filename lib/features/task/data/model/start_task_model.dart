import 'package:pikquick/features/task/domain/entitties/start_entity.dart';

class StartTaskModel extends StartTaskEntity {
  const StartTaskModel({
    required super.taskId,
  });

  factory StartTaskModel.fromJson(Map<String, dynamic> json) {
    return StartTaskModel(
      taskId: json['task_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
    };
  }
}
