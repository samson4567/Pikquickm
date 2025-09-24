// start_task_entity.dart
import 'package:equatable/equatable.dart';

class StartTaskEntity extends Equatable {
  final String taskId;

  const StartTaskEntity({
    required this.taskId,
  });

  @override
  List<Object?> get props => [taskId];
}
