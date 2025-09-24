// mark_as_completed_entity.dart
import 'package:equatable/equatable.dart';

class MarkAsCompletedEntity extends Equatable {
  final String taskId;

  const MarkAsCompletedEntity({
    required this.taskId,
  });

  @override
  List<Object?> get props => [taskId];
}
