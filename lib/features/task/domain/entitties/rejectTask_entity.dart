import 'package:equatable/equatable.dart';

class RunnerRejectTaskEntity extends Equatable {
  final String taskId;

  const RunnerRejectTaskEntity({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
