import 'package:pikquick/features/task/domain/entitties/acceot_task_entity.dart';

class AcceptTaskByRunnerModel extends AcceptTaskByRunnerEntity {
  AcceptTaskByRunnerModel({required super.taskId});

  factory AcceptTaskByRunnerModel.fromJson(Map<String, dynamic> json) {
    return AcceptTaskByRunnerModel(
      taskId: json['task_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
    };
  }
}
