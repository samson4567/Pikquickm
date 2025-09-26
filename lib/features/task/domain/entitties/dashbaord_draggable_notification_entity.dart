import 'package:equatable/equatable.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_entities.dart';
import 'package:pikquick/features/transaction/data/model/bid_history_model.dart';

class DashbaordDraggableNotificationEntity extends Equatable {
  final BidHistoryModel? bidHistoryModel;
  final GetTaskForCurrenusersEntity? taskModel;

  const DashbaordDraggableNotificationEntity({
    this.bidHistoryModel,
    this.taskModel,
  });

  @override
  List<Object?> get props => [
        bidHistoryModel,
        taskModel,
      ];
}
