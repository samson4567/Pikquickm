import 'package:equatable/equatable.dart';
import 'package:pikquick/features/task/data/model/accept_bid.dart';
import 'package:pikquick/features/task/data/model/accept_task_model.dart';
import 'package:pikquick/features/task/data/model/active_task_model.dart';
import 'package:pikquick/features/task/data/model/assign_task_model.dart';
import 'package:pikquick/features/task/data/model/bid_offer_model.dart';
import 'package:pikquick/features/task/data/model/complete_task_model.dart';
import 'package:pikquick/features/task/data/model/get_task_currentusermodel.dart';
import 'package:pikquick/features/task/data/model/get_task_runner_model.dart';
import 'package:pikquick/features/task/data/model/new_task_model.dart';
import 'package:pikquick/features/task/data/model/reject_bid_model.dart';
import 'package:pikquick/features/task/data/model/rejecttask_model.dart';
import 'package:pikquick/features/task/data/model/specialize_model.dart';
import 'package:pikquick/features/task/data/model/start_task_model.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskCreationEvent extends TaskEvent {
  final TaskModel taskModel;

  const TaskCreationEvent({required this.taskModel});

  @override
  List<Object> get props => [taskModel];
}

class SavedCategoriesEvent extends TaskEvent {
  final SavedCategoriesModel saveModel;
  const SavedCategoriesEvent({required this.saveModel});
  @override
  List<Object> get props => [saveModel];
}

class GetTaskForCurrenusersEvent extends TaskEvent {
  final String? mode;

  const GetTaskForCurrenusersEvent({
    this.mode,
  });

  @override
  List<Object> get props => [];

  // get mode => null;
}

class GetTaskforRunnerEvent extends TaskEvent {
  final GetTaskForRunnerModel getTaskRunner;
  const GetTaskforRunnerEvent({required this.getTaskRunner});
  @override
  List<Object> get props => [getTaskRunner];
}

class ActivetaskEvent extends TaskEvent {
  final ActiveTaskPendingModel getTaskRunner;
  const ActivetaskEvent({required this.getTaskRunner});
  @override
  List<Object> get props => [getTaskRunner];
}

class GetTaskOverviewEvent extends TaskEvent {
  final String taskId;
  const GetTaskOverviewEvent({
    required this.taskId,
  });
  @override
  List<Object> get props => [taskId];
}
//GetTaskOverViewDetails

class GetTaskOverViewDetailsEvent extends TaskEvent {
  final String taskId;
  const GetTaskOverViewDetailsEvent({
    required this.taskId,
  });
  @override
  List<Object> get props => [taskId];
}

class RunnerTaskOverviewgEvent extends TaskEvent {
  final String taskId;
  const RunnerTaskOverviewgEvent({
    required this.taskId,
  });
  @override
  List<Object> get props => [taskId];
}

//GetNewTaskEvent

class GetNewTaskEvent extends TaskEvent {
  final NewTaskModel newtask;
  const GetNewTaskEvent({
    required this.newtask,
  });
  @override
  List<Object> get props => [newtask];
}

// InviteRunnerToTask
class InviteRunnerToTaskEvent extends TaskEvent {
  final String taskId;
  final String runnerId;

  const InviteRunnerToTaskEvent({required this.runnerId, required this.taskId});

  @override
  List<Object> get props => [taskId, runnerId];
}

//BidOfferEvent
class BidOfferEvent extends TaskEvent {
  final InitialBidOfferModel model;

  const BidOfferEvent({
    required this.model,
  });

  @override
  List<Object> get props => [model];
}

//BidOfferEvent
class UserAdressEvent extends TaskEvent {
  final String taskId;
  const UserAdressEvent({required this.taskId});
  @override
  List<Object> get props => [
        taskId,
      ];
}

//AcceptTaskbyrunner
class AcceptTaskbyrunnerEvent extends TaskEvent {
  final AcceptTaskByRunnerModel model;

  const AcceptTaskbyrunnerEvent({required this.model});

  @override
  List<Object> get props => [model];
}

//RejectTaskbyrunner
class RejectTaskbyrunnerEvent extends TaskEvent {
  final RunnerRejectTaskModel model;
  const RejectTaskbyrunnerEvent({required this.model});
  @override
  List<Object> get props => [model];
}

//AssignTaskRunner

class AssignTaskEvent extends TaskEvent {
  final AssignTaskModel taskAssign;
  const AssignTaskEvent({required this.taskAssign});
  @override
  List<Object> get props => [taskAssign];
}

class AcceptBidEvent extends TaskEvent {
  final String acceptBid;

  const AcceptBidEvent({required this.acceptBid});

  @override
  List<Object> get props => [acceptBid];
}

// task_event.dart (or bid_reject_event.dart)
class BidRejectEvent extends TaskEvent {
  final String bidReject;

  const BidRejectEvent({required this.bidReject});

  @override
  List<Object> get props => [bidReject];
}

// task_event.dart (or start_task_event.dart)
class StartTaskEvent extends TaskEvent {
  final StartTaskModel startTask;

  const StartTaskEvent({required this.startTask});

  @override
  List<Object> get props => [startTask];
}

// task_event.dart (or mark_as_completed_event.dart)
class MarkAsCompletedEvent extends TaskEvent {
  final MarkAsCompletedModel markAsCompleted;

  const MarkAsCompletedEvent({required this.markAsCompleted});

  @override
  List<Object> get props => [markAsCompleted];
}
