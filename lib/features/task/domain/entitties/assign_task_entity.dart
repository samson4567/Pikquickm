// assign_task_entity.dart
import 'package:equatable/equatable.dart';

class AssignTaskEntity extends Equatable {
  final String taskId;
  final String runnerId;

  const AssignTaskEntity({
    required this.taskId,
    required this.runnerId,
  });

  @override
  List<Object?> get props => [taskId, runnerId];
}
