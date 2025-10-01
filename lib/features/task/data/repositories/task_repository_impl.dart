import 'package:dartz/dartz.dart';
import 'package:pikquick/core/constants/endpoint_constant.dart';
import 'package:pikquick/core/error/exception.dart';
import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/core/mapper/failure_mapper.dart';
import 'package:pikquick/features/profile/data/model/wallet_summary_model.dart';
import 'package:pikquick/features/profile/domain/entities/wallet_entities.dart';
import 'package:pikquick/features/task/data/model/accept_bid.dart';
import 'package:pikquick/features/task/data/model/accept_task_model.dart';
import 'package:pikquick/features/task/data/model/active_task_model.dart';
import 'package:pikquick/features/task/data/model/assign_task_model.dart';
import 'package:pikquick/features/task/data/model/bid_offer_model.dart';
import 'package:pikquick/features/task/data/model/complete_task_model.dart';
import 'package:pikquick/features/task/data/model/get_task_currentusermodel.dart';
import 'package:pikquick/features/task/data/datasources/taskLocal_datasource.dart';
import 'package:pikquick/features/task/data/datasources/task_remote_datasource.dart';
import 'package:pikquick/features/task/data/model/get_task_runner_model.dart';
import 'package:pikquick/features/task/data/model/new_task_model.dart';
import 'package:pikquick/features/task/data/model/reject_bid_model.dart';
import 'package:pikquick/features/task/data/model/rejecttask_model.dart';
import 'package:pikquick/features/task/data/model/start_task_model.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/features/task/domain/entitties/acceot_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/accet_bid_enity.dart';
import 'package:pikquick/features/task/domain/entitties/active_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/assign_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/bid_offer_entity.dart';
import 'package:pikquick/features/task/domain/entitties/complete_entites.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_entities.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_overview_entity.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_runner_entity.dart';
import 'package:pikquick/features/task/domain/entitties/new_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/rejectTask_entity.dart';
import 'package:pikquick/features/task/domain/entitties/reject_bid_entity.dart';
import 'package:pikquick/features/task/domain/entitties/runner_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/specialize_entity.dart';
import 'package:pikquick/features/task/domain/entitties/start_entity.dart';
import 'package:pikquick/features/task/domain/repository/repository.dart';
import 'package:pikquick/features/transaction/domain/entities/user_address_enties.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(
      {required this.taskRemoteDatasource, required this.taskLocalDatasource});
  final TaskRemoteDatasource taskRemoteDatasource;
  final TaskLocalDatasource taskLocalDatasource;

  @override
  Future<Either<Failure, TaskModel>> taskcreation({
    required TaskModel taskModel,
  }) async {
    try {
      final result = await taskRemoteDatasource.taskcreation(
          taskModel: taskModel); // returns TaskModel
      return right(result);
    } catch (e) {
      print(
          "ajsbdajkdbskjbdsadabda-TaskRepositoryImpl-taskcreation-error_is>>${e}");
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<GetTaskForCurrenusersEntity>>> getTask(
      {required String? mode}) async {
    try {
      final result = await taskRemoteDatasource.getTask(mode: mode);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<GetTaskForRunnerEntity>>> getTaskforRunner(
      {required GetTaskForRunnerModel getTaskRunner}) async {
    try {
      final result = await taskRemoteDatasource.getTaskrunner(
          getTaskRunner: getTaskRunner);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ActiveTaskPendingEntity>>> getactiveTask({
    required ActiveTaskPendingModel getTaskRunner,
  }) async {
    try {
      final result = await taskRemoteDatasource.getActiveTask(
        getTaskRunner: getTaskRunner,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetTaskOverviewEntity>> tasoverview(
      {required String taskId}) async {
    try {
      final result = await taskRemoteDatasource.taskoverview(taskId: taskId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RunnerTaskOverviewEntity>> taskOverviewforruunner(
      {required String taskId}) async {
    try {
      final result =
          await taskRemoteDatasource.taskoverviewRunner(taskId: taskId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, NewTaskEntity>> newDetailsTask(
      {required String taskId}) async {
    try {
      final result = await taskRemoteDatasource.newDetailsTask(taskId: taskId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> inviteRunnerToTask({
    required String taskId,
    required String runnerId,
  }) async {
    try {
      final result = await taskRemoteDatasource.inviteRunnerToTask(
        taskId: taskId,
        runnerId: runnerId,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SavedCategoriesEntity>>> categorySaved(
      {required saveModel}) {
    // TODO: implement categorySaved
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<NewTaskEntity>>> newtask(
      {required NewTaskModel newtask}) async {
    try {
      final result = await taskRemoteDatasource.newtask(newtask: newtask);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, InitialBidOfferEntity>> offerAbid({
    required InitialBidOfferModel model,
  }) async {
    try {
      final result = await taskRemoteDatasource.offerAbid(model: model);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AcceptTaskByRunnerEntity>> runneracceptTask({
    required AcceptTaskByRunnerModel taskId,
  }) async {
    try {
      final result = await taskRemoteDatasource.runnerAcceptatask(
        taskId: taskId,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RunnerRejectTaskEntity>> runnerRejectTask(
      {required RunnerRejectTaskModel taskId}) async {
    try {
      final result = await taskRemoteDatasource.runnerRejecttask(
        taskId: taskId,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AssignTaskEntity>> taskAssigned(
      {required AssignTaskModel taskAssigned}) async {
    try {
      final result = await taskRemoteDatasource.assignesTask(
        taskAssigned: taskAssigned,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PickupDropoffEntity>> userAddress(
      {required String taskId}) async {
    {
      try {
        final result = await taskRemoteDatasource.userAdress(
          taskId: taskId,
        );
        return right(result);
      } catch (e) {
        return left(mapExceptionToFailure(e));
      }
    }
  }

  @override
  Future<Either<Failure, AcceptBidEntity>> acceptBid(
      {required String bidId}) async {
    try {
      final AcceptBidModel result = await taskRemoteDatasource.acceptBid(
        bidId: bidId,
      );
      return right(result); // result is a model but also an entity
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BidRejectEntity>> bidReject(
      {required String bidId}) async {
    try {
      final BidRejectModel result = await taskRemoteDatasource.bidReject(
        bidId: bidId,
      );
      return right(result); // Model extends Entity
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StartTaskEntity>> startTask({
    required StartTaskModel startTask,
  }) async {
    try {
      final StartTaskModel result = await taskRemoteDatasource.startTask(
        startTask: startTask,
      );
      return right(result); // Model extends Entity
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MarkAsCompletedEntity>> markAsCompleted({
    required MarkAsCompletedModel markAsCompleted,
  }) async {
    try {
      final MarkAsCompletedModel result =
          await taskRemoteDatasource.markAsCompleted(
        markAsCompleted: markAsCompleted,
      );
      return right(result); // Model extends Entity
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, WalletSummaryEntity>> getWalletSummary(
      {required WalletSummaryModel model}) async {
    try {
      final result = await taskRemoteDatasource.getWalletSummary(model: model);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
