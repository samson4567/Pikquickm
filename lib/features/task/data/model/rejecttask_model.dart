import 'package:pikquick/features/task/domain/entitties/rejectTask_entity.dart';

class RunnerRejectTaskModel extends RunnerRejectTaskEntity {
  const RunnerRejectTaskModel({
    required super.taskId,
  });

  factory RunnerRejectTaskModel.fromJson(Map<String, dynamic> json) {
    return RunnerRejectTaskModel(
      taskId: json['task_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
    };
  }
}
