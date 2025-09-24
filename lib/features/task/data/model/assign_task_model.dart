// assign_task_model.dart
import 'package:pikquick/features/task/domain/entitties/assign_task_entity.dart';

class AssignTaskModel extends AssignTaskEntity {
  const AssignTaskModel({
    required super.taskId,
    required super.runnerId,
  });

  // From JSON
  factory AssignTaskModel.fromJson(Map<String, dynamic> json) {
    return AssignTaskModel(
      taskId: json['task_id'] ?? "",
      runnerId: json['runner_id'] ?? "",
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      "task_id": taskId,
      "runner_id": runnerId,
    };
  }
}
