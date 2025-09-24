import 'package:pikquick/core/api/pickquick_network_client.dart';
import 'package:pikquick/core/constants/endpoint_constant.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/features/task/data/model/accept_bid.dart';
import 'package:pikquick/features/task/data/model/accept_task_model.dart';
import 'package:pikquick/features/task/data/model/active_task_model.dart';
import 'package:pikquick/features/task/data/model/assign_task_model.dart';
import 'package:pikquick/features/task/data/model/bid_offer_model.dart';
import 'package:pikquick/features/task/data/model/complete_task_model.dart';
import 'package:pikquick/features/task/data/model/get_task_currentusermodel.dart';
import 'package:pikquick/features/task/data/model/get_task_overview_model.dart';
import 'package:pikquick/features/task/data/model/get_task_runner_model.dart';
import 'package:pikquick/features/task/data/model/new_task_model.dart';
import 'package:pikquick/features/task/data/model/reject_bid_model.dart';
import 'package:pikquick/features/task/data/model/rejecttask_model.dart';
import 'package:pikquick/features/task/data/model/runner_task_model.dart';
import 'package:pikquick/features/task/data/model/specialize_model.dart';
import 'package:pikquick/features/task/data/model/start_task_model.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/features/transaction/data/model/user_address_model.dart';

abstract class TaskRemoteDatasource {
  Future<TaskModel> taskcreation({required TaskModel taskModel});
  Future<List<SavedCategoriesModel>> categorySaved(
      {required SavedCategoriesModel saveModel});
  Future<List<GetTaskForClientModel>> getTask(
      {required GetTaskForClientModel gettaskModel});
  Future<List<GetTaskForRunnerModel>> getTaskrunner(
      {required GetTaskForRunnerModel getTaskRunner});
  Future<List<ActiveTaskPendingModel>> getActiveTask(
      {required ActiveTaskPendingModel getTaskRunner});
  Future<GetTaskOverviewModel> taskoverview({required String taskId});
  Future<RunnerTaskOverviewgModel> taskoverviewRunner({required String taskId});
  Future<String> inviteRunnerToTask({
    required String taskId,
    required String runnerId,
  });
  Future<List<NewTaskModel>> newtask({
    required NewTaskModel newtask,
  });
  Future<NewTaskModel> newDetailsTask({required String taskId});
  Future<InitialBidOfferModel> offerAbid({required InitialBidOfferModel model});
  Future<AcceptTaskByRunnerModel> runnerAcceptatask({
    required AcceptTaskByRunnerModel taskId,
  });
  Future<AssignTaskModel> assignesTask({
    required AssignTaskModel taskAssigned,
  });
  Future<RunnerRejectTaskModel> runnerRejecttask({
    required RunnerRejectTaskModel taskId,
  });
  Future<PickupDropoffModel> userAdress({
    required String taskId,
  });
  Future<AcceptBidModel> acceptBid({
    required String bidId,
  });

  Future<BidRejectModel> bidReject({
    required String bidId,
  });
  Future<StartTaskModel> startTask({
    required StartTaskModel startTask,
  });
  Future<MarkAsCompletedModel> markAsCompleted({
    required MarkAsCompletedModel markAsCompleted,
  });
}

//newDetailsTask
class TaskRemoteDatasourceIpl implements TaskRemoteDatasource {
  final AppPreferenceService appPreferenceService;

  final PikquickNetworkClient networkClient;
  TaskRemoteDatasourceIpl({
    required this.networkClient,
    required this.appPreferenceService,
  });

  @override
  Future<TaskModel> taskcreation({required TaskModel taskModel}) async {
    print('taskModel.toJson() => ${taskModel.toJson()}');
    final response = await networkClient.post(
      endpoint: EndpointConstant.createTask,
      isAuthHeaderRequired: true,
      data: taskModel.toJson(),
    );

    final data = response.data;
    return TaskModel.fromJson(data);
  }

  @override
  Future<List<SavedCategoriesModel>> categorySaved(
      {required SavedCategoriesModel saveModel}) async {
    final response = await networkClient.put(
      endpoint: EndpointConstant.savedCategories,
      isAuthHeaderRequired: true,
    );
    var items = (response.data as List).map((item) {
      return SavedCategoriesModel.fromJson(item);
    }).toList();
    return items;
  }

  @override
  Future<List<GetTaskForClientModel>> getTask(
      {required GetTaskForClientModel gettaskModel}) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.gettaskforcurrentusers,
      isAuthHeaderRequired: true,
    );
    var items = (response.data as List).map((item) {
      return GetTaskForClientModel.fromJson(item);
    }).toList();

    return items;
  }

  @override
  Future<List<GetTaskForRunnerModel>> getTaskrunner(
      {required GetTaskForRunnerModel getTaskRunner}) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.gettaskActive,
      isAuthHeaderRequired: true,
    );
    var items = (response.data as List).map((item) {
      return GetTaskForRunnerModel.fromJson(item);
    }).toList();

    return items;
  }

  @override
  Future<GetTaskOverviewModel> taskoverview({required String taskId}) async {
    print('${taskId}************ ');
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.runnerOverviewTask}/$taskId',
      isAuthHeaderRequired: true,
      params: {'taskId': taskId},
    );

    return GetTaskOverviewModel.fromJson(response.data);
  }

  @override
  Future<RunnerTaskOverviewgModel> taskoverviewRunner({
    required String taskId,
  }) async {
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.runnerOverviewTask}/$taskId',
      isAuthHeaderRequired: true,
      params: {'taskId': taskId},
    );
    return RunnerTaskOverviewgModel.fromJson(response.data);
  }

  @override
  Future<String> inviteRunnerToTask({
    required String taskId,
    required String runnerId,
  }) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.getallTaskCategories,
      isAuthHeaderRequired: true,
    );
    return response.message;
  }

  @override
  Future<List<NewTaskModel>> newtask({required NewTaskModel newtask}) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.availableTask,
      isAuthHeaderRequired: true,
    );
    var items = (response.data as List).map((item) {
      return NewTaskModel.fromJson(item);
    }).toList();

    return items;
  }

  @override
  Future<NewTaskModel> newDetailsTask({required String taskId}) async {
    print('${taskId}************ ');
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.availableTaskOverview}/$taskId',
      isAuthHeaderRequired: true,
      params: {'taskId': taskId},
    );
    return NewTaskModel.fromJson(response.data);
  }

  @override
  Future<InitialBidOfferModel> offerAbid(
      {required InitialBidOfferModel model}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.offerAbid,
        isAuthHeaderRequired: true,
        data: model.toJson());
    return InitialBidOfferModel.fromJson(response.data);
  }

  @override
  Future<AcceptTaskByRunnerModel> runnerAcceptatask(
      {required AcceptTaskByRunnerModel taskId}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.acceptTask,
      isAuthHeaderRequired: true,
      data: taskId.toJson(),
    );
    print('Response data********************: ${response.message}');
    return AcceptTaskByRunnerModel.fromJson(response.data);
  }

  @override
  Future<RunnerRejectTaskModel> runnerRejecttask(
      {required RunnerRejectTaskModel taskId}) async {
    final response = await networkClient.put(
      endpoint: EndpointConstant.rejectTask,
      isAuthHeaderRequired: true,
      data: taskId.toJson(),
    );
    print('Response data********************: ${response.message}');
    return RunnerRejectTaskModel.fromJson(response.data);
  }

  @override
  Future<List<ActiveTaskPendingModel>> getActiveTask(
      {required ActiveTaskPendingModel getTaskRunner}) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.gettaskActive,
      isAuthHeaderRequired: true,
    );
    var items = (response.data as List).map((item) {
      return ActiveTaskPendingModel.fromJson(item);
    }).toList();

    return items;
  }

  @override
  Future<AssignTaskModel> assignesTask(
      {required AssignTaskModel taskAssigned}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.taskAssigned,
      isAuthHeaderRequired: true,
      data: taskAssigned.toJson(),
    );
    print('Response data********************: ${response.message}');
    return AssignTaskModel.fromJson(response.data);
  }

  @override
  Future<PickupDropoffModel> userAdress({required String taskId}) async {
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.userAdress}/$taskId/locations',
      isAuthHeaderRequired: true,
      params: {'taskId': taskId},
    );

    return PickupDropoffModel.fromJson(response.data);
  }

  @override
  Future<AcceptBidModel> acceptBid({required String bidId}) async {
    if (bidId.isEmpty) throw ArgumentError('bidId cannot be empty');
    final response = await networkClient.put(
      endpoint: EndpointConstant.acceptBids,
      isAuthHeaderRequired: true,
      data: {'bid_id': bidId},
    );
    return AcceptBidModel.fromJson(response.data);
  }

  @override
  Future<BidRejectModel> bidReject({required String bidId}) async {
    if (bidId.isEmpty) throw ArgumentError('bidId cannot be empty');
    final response = await networkClient.put(
      endpoint: EndpointConstant.rejectBids,
      isAuthHeaderRequired: true,
      data: {'bid_id': bidId},
    );
    return BidRejectModel.fromJson(response.data);
  }

  @override
  Future<StartTaskModel> startTask({
    required StartTaskModel startTask,
  }) async {
    final response = await networkClient.put(
      endpoint: EndpointConstant.starttask,
      isAuthHeaderRequired: true,
      data: startTask.toJson(),
    );

    return StartTaskModel.fromJson(response.data);
  }

  @override
  Future<MarkAsCompletedModel> markAsCompleted({
    required MarkAsCompletedModel markAsCompleted,
  }) async {
    final response = await networkClient.put(
      endpoint: EndpointConstant.completeTask,
      isAuthHeaderRequired: true,
      data: markAsCompleted.toJson(),
    );

    return MarkAsCompletedModel.fromJson(response.data);
  }
}
