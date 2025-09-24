import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/features/task/domain/repository/repository.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  TaskBloc({
    required this.taskRepository,
  }) : super(const TaskInitial()) {
    // on<TaskCreationEvent>(_onTaskEvent);
    // on<TaskCreationEvent>(_onTaskCreationEvent);
    on<SavedCategoriesEvent>(_onSavedCategories);
    on<GetTaskForCurrenusersEvent>(_onGetTaskCurrentUsers);
    on<GetTaskforRunnerEvent>(_onGettaskforRunner);
    on<ActivetaskEvent>(_onActiveTask);
    on<GetTaskOverviewEvent>(_onGetTaskView);
    on<TaskCreationEvent>(_onTaskCreationEvent);
    on<InviteRunnerToTaskEvent>(_onInviteRunnerToTaskEvent);
    on<GetNewTaskEvent>(_onGetNewTaskAvailable);
    on<GetTaskOverViewDetailsEvent>(_onGetTaskViewDetails);
    on<BidOfferEvent>(_onBidOffer);
    on<AcceptTaskbyrunnerEvent>(_onAccepttaskbyRunner);
    on<RejectTaskbyrunnerEvent>(_onRejecttaskbyRunner);
    on<RunnerTaskOverviewgEvent>(_onRunnerTaskOverviewg);
    on<AssignTaskEvent>(_onAssignTask);
    on<UserAdressEvent>(_onuserAdress);
    on<AcceptBidEvent>(_onAcceptBid);
    on<BidRejectEvent>(_onBidReject);
    on<StartTaskEvent>(_onStartTask);
    on<MarkAsCompletedEvent>(_onMarkAsCompleted);
  }

// taskcreation
  Future<void> _onTaskCreationEvent(
      TaskCreationEvent event, Emitter<TaskState> emit) async {
    emit(TaskCreationLoadingState());
    final result =
        await taskRepository.taskcreation(taskModel: event.taskModel);
    result.fold(
      (error) => emit(TaskCreationErrorState(message: error.message)),
      (data) => emit(TaskCreationSuccessState(resultantTaskModel: data)),
    );
  }

  Future<void> _onInviteRunnerToTaskEvent(
      InviteRunnerToTaskEvent event, Emitter<TaskState> emit) async {
    emit(InviteRunnerToTaskLoadingState());
    final result = await taskRepository.inviteRunnerToTask(
        taskId: event.taskId, runnerId: event.runnerId);
    result.fold(
      (error) => emit(InviteRunnerToTaskErrorState(message: error.message)),
      (message) => emit(InviteRunnerToTaskSuccessState(message: message)),
    );
  }

  Future<void> _onSavedCategories(
      SavedCategoriesEvent event, Emitter<TaskState> emit) async {
    emit(SavedcategoriesLoadingState());
    final result =
        await taskRepository.categorySaved(saveModel: event.saveModel);
    result.fold(
      (error) => emit(SavedcategoriesErrorState(errorMessage: error.message)),
      (data) => emit(SavedcategoriesSuccessState(savedSpecializatin: data)),
    );
  }

  Future<void> _onGetTaskCurrentUsers(
      GetTaskForCurrenusersEvent event, Emitter<TaskState> emit) async {
    emit(GetTaskForCurrenusersLoadingState());
    final result =
        await taskRepository.getTask(gettaskModel: event.gettaskModel);
    result.fold(
      (error) =>
          emit(GetTaskForCurrenusersErrorState(errorMessage: error.message)),
      (data) => emit(GetTaskForCurrenusersSucessState(gettask: data)),
    );
  }

  Future<void> _onGettaskforRunner(
      GetTaskforRunnerEvent event, Emitter<TaskState> emit) async {
    emit(GetTaskforRunnerLoadingState());
    final result = await taskRepository.getTaskforRunner(
        getTaskRunner: event.getTaskRunner);
    result.fold(
      (error) => emit(GetTaskforRunnerErrorState(errorMessage: error.message)),
      (data) => emit(GetTaskforRunnerSuccessState(runnertask: data)),
    );
  }

  Future<void> _onActiveTask(
      ActivetaskEvent event, Emitter<TaskState> emit) async {
    emit(ActivetaskLoadingState());
    final result =
        await taskRepository.getactiveTask(getTaskRunner: event.getTaskRunner);
    result.fold(
      (error) => emit(ActivetaskErrorState(errorMessage: error.message)),
      (data) => emit(ActivetaskSuccessState(runnertask: data)),
    );
  }

  Future<void> _onGetTaskView(
      GetTaskOverviewEvent event, Emitter<TaskState> emit) async {
    emit(GetTaskOverviiewLoadingState());
    final result = await taskRepository.tasoverview(taskId: event.taskId);
    result.fold(
      (error) => emit(GetTaskOverviiewErrorState(errorMessage: error.message)),
      (data) => emit(GetTaskOverviiewSuccessState(taskOverView: data)),
    );
  }

  Future<void> _onGetTaskViewDetails(
      GetTaskOverViewDetailsEvent event, Emitter<TaskState> emit) async {
    emit(GetNewTaskDetailsLoadingState());
    final result = await taskRepository.newDetailsTask(taskId: event.taskId);
    result.fold(
      (error) => emit(GetNewTaskDetailsErrorState(errorMessage: error.message)),
      (data) => emit(GetNewTaskDetailsSuccessState(taskOverViewDetails: data)),
    );
  }

  Future<void> _onRunnerTaskOverviewg(
      RunnerTaskOverviewgEvent event, Emitter<TaskState> emit) async {
    emit(RunnerTaskOverViewLoadingState());
    final result =
        await taskRepository.taskOverviewforruunner(taskId: event.taskId);
    result.fold(
      (error) =>
          emit(RunnerTaskOverViewErrorState(errorMessage: error.message)),
      (data) => emit(RunnerTaskOverViewSuccessState(taskOverView: data)),
    );
  }

  Future<void> _onGetNewTaskAvailable(
      GetNewTaskEvent event, Emitter<TaskState> emit) async {
    emit(GetNewTaskLoadingState());
    final result = await taskRepository.newtask(newtask: event.newtask);
    result.fold(
      (error) => emit(GetNewTaskErrorState(errorMessage: error.message)),
      (data) => emit(GetNewTaskSuccessState(getNewTask: data)),
    );
  }

  Future<void> _onAssignTask(
      AssignTaskEvent event, Emitter<TaskState> emit) async {
    emit(AssignTaskLoadingState());
    final result =
        await taskRepository.taskAssigned(taskAssigned: event.taskAssign);
    result.fold(
      (error) => emit(AssignTaskeSErrorState(message: error.message)),
      (data) => emit(AssignTaskeSuccessState(message: data)),
    );
  }

  Future<void> _onBidOffer(BidOfferEvent event, Emitter<TaskState> emit) async {
    emit(BidofferLoadingState());
    final result = await taskRepository.offerAbid(model: event.model);
    result.fold(
      (error) => emit(BidOfferErrorState(message: error.message)),
      (data) => emit(BidOfferSuccessState(message: "Bid Offers sent")),
    );
  }

  Future<void> _onuserAdress(
    UserAdressEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(UserAdressLoadingState());

    final result = await taskRepository.userAddress(
      taskId: event.taskId,
    );
    result.fold(
      (error) => emit(UserAdresErrorState(message: error.message)),
      (data) => emit(UserAdressSuccessState(
          message: "userAddress")), // or any message from `data`
    );
  }

  Future<void> _onAccepttaskbyRunner(
    AcceptTaskbyrunnerEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(AcceptTaskbyrunnerLoadingState());

    final result = await taskRepository.runneracceptTask(
      taskId: event.model, // correctly passing the model now
    );

    result.fold(
      (error) => emit(AcceptTaskbyrunnerErrorState(message: error.message)),
      (data) => emit(AcceptTaskbyrunnerSuccessState(
          message: "Task accepted successfully")), // or any message from `data`
    );
  }

  Future<void> _onRejecttaskbyRunner(
      RejectTaskbyrunnerEvent event, Emitter<TaskState> emit) async {
    emit(RejectTaskbyrunnerLoadingState());
    final result = await taskRepository.runnerRejectTask(
      taskId: event.model,
    );
    result.fold(
      (error) => emit(RejectTaskbyrunnerErrorState(message: error.message)),
      (data) => emit(RejectTaskbyrunnerSuccessState(message: "Task Rejected")),
    );
  }

  Future<void> _onAcceptBid(
    AcceptBidEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(AcceptBidLoadingState());

    final result = await taskRepository.acceptBid(bidId: event.acceptBid);

    result.fold(
      (error) => emit(AcceptBidErrorState(message: error.message)),
      (data) =>
          emit(AcceptBidSuccessState(messsage: 'Task Accepted Successfully ')),
    );
  }

  Future<void> _onBidReject(
    BidRejectEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(BidRejectLoadingState());

    final result = await taskRepository.bidReject(bidId: event.bidReject);

    result.fold(
      (error) => emit(BidRejectErrorState(message: error.message)),
      (data) => emit(BidRejectSuccessState(message: data)),
    );
  }

  Future<void> _onStartTask(
    StartTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(StartTaskLoadingState());

    final result = await taskRepository.startTask(startTask: event.startTask);

    result.fold(
      (error) => emit(StartTaskErrorState(message: error.message)),
      (data) => emit(StartTaskSuccessState(message: data)),
    );
  }

  Future<void> _onMarkAsCompleted(
    MarkAsCompletedEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(MarkAsCompletedLoadingState());

    final result = await taskRepository.markAsCompleted(
      markAsCompleted: event.markAsCompleted,
    );

    result.fold(
      (error) => emit(MarkAsCompletedErrorState(message: error.message)),
      (data) => emit(MarkAsCompletedSuccessState(message: data)),
    );
  }
}
