import 'package:equatable/equatable.dart';
import 'package:pikquick/features/task/domain/entitties/accet_bid_enity.dart';
import 'package:pikquick/features/task/domain/entitties/active_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/assign_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/complete_entites.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_entities.dart'
    show GetTaskForCurrenusersEntity;
import 'package:pikquick/features/task/domain/entitties/get_task_overview_entity.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_runner_entity.dart'
    show GetTaskForRunnerEntity;
import 'package:pikquick/features/task/domain/entitties/new_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/reject_bid_entity.dart';
import 'package:pikquick/features/task/domain/entitties/runner_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/specialize_entity.dart';
import 'package:pikquick/features/task/domain/entitties/start_entity.dart';
import 'package:pikquick/features/task/domain/entitties/taskcreation_entity.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskInitial extends TaskState {
  const TaskInitial();
}

final class TaskLoadingState extends TaskState {}

final class TaskSuccessState extends TaskState {
  const TaskSuccessState({required this.createtask});
  final List<TaskEntity> createtask;
  @override
  List<Object> get props => [createtask];
}

final class TaskErrorState extends TaskState {
  const TaskErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

//Savedcategories
final class Savedcategoriesintial extends TaskState {
  const Savedcategoriesintial();
}

final class SavedcategoriesLoadingState extends TaskState {}

final class SavedcategoriesSuccessState extends TaskState {
  final List<SavedCategoriesEntity> savedSpecializatin;
  const SavedcategoriesSuccessState({required this.savedSpecializatin});
}

final class SavedcategoriesErrorState extends TaskState {
  const SavedcategoriesErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// GetTaskForCurrentUser
final class GetTaskForCurrenusersInital extends TaskState {
  const GetTaskForCurrenusersInital();
}

final class GetTaskForCurrenusersLoadingState extends TaskState {}

final class GetTaskForCurrenusersSucessState extends TaskState {
  final List<GetTaskForCurrenusersEntity> gettask;
  const GetTaskForCurrenusersSucessState({required this.gettask});
  @override
  List<Object> get props => [gettask];
}

final class GetTaskForCurrenusersErrorState extends TaskState {
  const GetTaskForCurrenusersErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

//GetTaskForRunner

final class GetTaskforRunnerIntitial extends TaskState {
  const GetTaskforRunnerIntitial();
}

final class GetTaskforRunnerLoadingState extends TaskState {}

final class GetTaskforRunnerSuccessState extends TaskState {
  final List<GetTaskForRunnerEntity> runnertask;
  const GetTaskforRunnerSuccessState({
    required this.runnertask,
  });
  @override
  List<Object> get props => [runnertask];
}

final class GetTaskforRunnerErrorState extends TaskState {
  const GetTaskforRunnerErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

//activetaskforrunner
final class ActivetaskIntitial extends TaskState {
  const ActivetaskIntitial();
}

final class ActivetaskLoadingState extends TaskState {}

final class ActivetaskSuccessState extends TaskState {
  final List<ActiveTaskPendingEntity> runnertask;
  const ActivetaskSuccessState({
    required this.runnertask,
  });
  @override
  List<Object> get props => [runnertask];
}

final class ActivetaskErrorState extends TaskState {
  const ActivetaskErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

//GetTaskOverviiew
final class GetTaskOverviiewIntitial extends TaskState {
  const GetTaskOverviiewIntitial();
}

final class GetTaskOverviiewLoadingState extends TaskState {}

final class GetTaskOverviiewSuccessState extends TaskState {
  final GetTaskOverviewEntity taskOverView;
  const GetTaskOverviiewSuccessState({
    required this.taskOverView,
  });
  @override
  List<Object> get props => [taskOverView];
}

final class GetTaskOverviiewErrorState extends TaskState {
  const GetTaskOverviiewErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

//RunnerTaskOverView
final class RunnerTaskOverViewIntitial extends TaskState {
  const RunnerTaskOverViewIntitial();
}

final class RunnerTaskOverViewLoadingState extends TaskState {}

final class RunnerTaskOverViewSuccessState extends TaskState {
  final RunnerTaskOverviewEntity taskOverView;
  const RunnerTaskOverViewSuccessState({
    required this.taskOverView,
  });
  @override
  List<Object> get props => [taskOverView];
}

final class RunnerTaskOverViewErrorState extends TaskState {
  const RunnerTaskOverViewErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

//GetNewTaskDetails
final class GetNewTaskDetailsIntitial extends TaskState {
  const GetNewTaskDetailsIntitial();
}

final class GetNewTaskDetailsLoadingState extends TaskState {}

final class GetNewTaskDetailsSuccessState extends TaskState {
  final NewTaskEntity taskOverViewDetails;
  const GetNewTaskDetailsSuccessState({
    required this.taskOverViewDetails,
  });
  @override
  List<Object> get props => [taskOverViewDetails];
}

final class GetNewTaskDetailsErrorState extends TaskState {
  const GetNewTaskDetailsErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// GetAvailablOrNewTASK

// final class GetBidingTaskIntitial extends TaskState {
//   const GetBidingTaskIntitial();
// }

final class GetNewTaskLoadingState extends TaskState {}

final class GetNewTaskSuccessState extends TaskState {
  final List<NewTaskEntity> getNewTask;
  const GetNewTaskSuccessState({
    required this.getNewTask,
  });
  @override
  List<Object> get props => [getNewTask];
}

final class GetNewTaskErrorState extends TaskState {
  const GetNewTaskErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// task creation
final class TaskCreationSuccessState extends TaskState {
  const TaskCreationSuccessState({required this.resultantTaskModel});
  final TaskEntity resultantTaskModel;
  @override
  List<Object> get props => [resultantTaskModel];
}

final class TaskCreationLoadingState extends TaskState {
  const TaskCreationLoadingState();
  @override
  List<Object> get props => [];
}

final class TaskCreationErrorState extends TaskState {
  const TaskCreationErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

//inviteRunner
final class InviteRunnerToTaskSuccessState extends TaskState {
  const InviteRunnerToTaskSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class InviteRunnerToTaskLoadingState extends TaskState {
  const InviteRunnerToTaskLoadingState();
  @override
  List<Object> get props => [];
}

final class InviteRunnerToTaskErrorState extends TaskState {
  const InviteRunnerToTaskErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

//UserADress
final class UserAdressIniitalState extends TaskState {
  const UserAdressIniitalState();
  @override
  List<Object> get props => [];
}

final class UserAdressLoadingState extends TaskState {}

final class UserAdressSuccessState extends TaskState {
  const UserAdressSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class UserAdresErrorState extends TaskState {
  const UserAdresErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

// Bid offer

final class BidOfferInitalState extends TaskState {
  const BidOfferInitalState();
  @override
  List<Object> get props => [];
}

final class BidofferLoadingState extends TaskState {}

final class BidOfferSuccessState extends TaskState {
  const BidOfferSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class BidOfferErrorState extends TaskState {
  const BidOfferErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

// AcceptTaskbyrunner
final class AcceptTaskbyrunnerIniitalState extends TaskState {
  const AcceptTaskbyrunnerIniitalState();
  @override
  List<Object> get props => [];
}

final class AcceptTaskbyrunnerLoadingState extends TaskState {}

final class AcceptTaskbyrunnerSuccessState extends TaskState {
  const AcceptTaskbyrunnerSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class AcceptTaskbyrunnerErrorState extends TaskState {
  const AcceptTaskbyrunnerErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

//RejecTaskbyrunner
final class RejectTaskbyrunnerIniitalState extends TaskState {
  const RejectTaskbyrunnerIniitalState();
  @override
  List<Object> get props => [];
}

final class RejectTaskbyrunnerLoadingState extends TaskState {}

final class RejectTaskbyrunnerSuccessState extends TaskState {
  const RejectTaskbyrunnerSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class RejectTaskbyrunnerErrorState extends TaskState {
  const RejectTaskbyrunnerErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

//AssignTaskToRunner
final class AssignTaskIniitalState extends TaskState {
  const AssignTaskIniitalState();
  @override
  List<Object> get props => [];
}

final class AssignTaskLoadingState extends TaskState {}

final class AssignTaskeSuccessState extends TaskState {
  const AssignTaskeSuccessState({required this.message});
  final AssignTaskEntity message;
  @override
  List<Object> get props => [message];
}

final class AssignTaskeSErrorState extends TaskState {
  const AssignTaskeSErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class AcceptBidInitialState extends TaskState {
  const AcceptBidInitialState();
  @override
  List<Object> get props => [];
}

final class AcceptBidLoadingState extends TaskState {}

final class AcceptBidSuccessState extends TaskState {
  const AcceptBidSuccessState({required this.messsage});
  final String messsage;

  @override
  List<Object> get props => [messsage];
}

final class AcceptBidErrorState extends TaskState {
  const AcceptBidErrorState({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

// task_state.dart (or bid_reject_state.dart)
final class BidRejectInitialState extends TaskState {
  const BidRejectInitialState();
  @override
  List<Object> get props => [];
}

final class BidRejectLoadingState extends TaskState {}

final class BidRejectSuccessState extends TaskState {
  const BidRejectSuccessState({required this.message});
  final BidRejectEntity message;

  @override
  List<Object> get props => [message];
}

final class BidRejectErrorState extends TaskState {
  const BidRejectErrorState({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

// task_state.dart (or start_task_state.dart)
final class StartTaskInitialState extends TaskState {
  const StartTaskInitialState();
  @override
  List<Object> get props => [];
}

final class StartTaskLoadingState extends TaskState {}

final class StartTaskSuccessState extends TaskState {
  const StartTaskSuccessState({required this.message});
  final StartTaskEntity message;

  @override
  List<Object> get props => [message];
}

final class StartTaskErrorState extends TaskState {
  const StartTaskErrorState({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

// task_state.dart (or mark_as_completed_state.dart)
final class MarkAsCompletedInitialState extends TaskState {
  const MarkAsCompletedInitialState();
  @override
  List<Object> get props => [];
}

final class MarkAsCompletedLoadingState extends TaskState {}

final class MarkAsCompletedSuccessState extends TaskState {
  const MarkAsCompletedSuccessState({required this.message});
  final MarkAsCompletedEntity message;

  @override
  List<Object> get props => [message];
}

final class MarkAsCompletedErrorState extends TaskState {
  const MarkAsCompletedErrorState({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

// GetBidingTask
final class GetBidingTaskIntitial extends TaskState {
  const GetBidingTaskIntitial();
}

final class GetBidingTaskLoadingState extends TaskState {}

final class GetBidingTaskSuccessState extends TaskState {
  final List<NewTaskEntity> GetBidingTask;
  const GetBidingTaskSuccessState({
    required this.GetBidingTask,
  });
  @override
  List<Object> get props => [GetBidingTask];
}

final class GetBidingTaskErrorState extends TaskState {
  const GetBidingTaskErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}
