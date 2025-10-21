import 'package:dartz/dartz.dart';
import 'package:pikquick/core/error/failure.dart';
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
import 'package:pikquick/features/task/data/model/start_task_model.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/features/task/data/model/wallet_summary_model.dart';
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
import 'package:pikquick/features/task/domain/entitties/task_message_entity.dart';
import 'package:pikquick/features/task/domain/entitties/taskcreation_entity.dart';
import 'package:pikquick/features/task/domain/entitties/wallet_entities.dart';
import 'package:pikquick/features/transaction/domain/entities/user_address_enties.dart';

abstract class TaskRepository {
  Future<Either<Failure, TaskEntity>> taskcreation(
      {required TaskModel taskModel});
  Future<Either<Failure, List<SavedCategoriesEntity>>> categorySaved({
    required saveModel,
  });
  Future<Either<Failure, List<GetTaskForCurrenusersEntity>>> getTask(
      {required String? mode});

  Future<Either<Failure, List<GetTaskForRunnerEntity>>> getTaskforRunner(
      {required GetTaskForRunnerModel getTaskRunner});
  Future<Either<Failure, List<ActiveTaskPendingEntity>>> getactiveTask();
  Future<Either<Failure, GetTaskOverviewEntity>> tasoverview({
    required String taskId,
  });

  Future<Either<Failure, RunnerTaskOverviewEntity>> taskOverviewforruunner({
    required String taskId,
  });

  Future<Either<Failure, NewTaskEntity>> newDetailsTask({
    required String taskId,
  });

  Future<Either<Failure, String>> inviteRunnerToTask({
    required String taskId,
    required String runnerId,
  });
  Future<Either<Failure, InitialBidOfferEntity>> offerAbid(
      {required InitialBidOfferModel model});
  Future<Either<Failure, List<NewTaskEntity>>> newtask({
    required NewTaskModel newtask,
  });
  Future<Either<Failure, AssignTaskEntity>> taskAssigned({
    required AssignTaskModel taskAssigned,
  });
  Future<Either<Failure, AcceptTaskByRunnerEntity>> runneracceptTask({
    required AcceptTaskByRunnerModel taskId,
  });
  Future<Either<Failure, RunnerRejectTaskEntity>> runnerRejectTask({
    required RunnerRejectTaskModel taskId,
  });

  Future<Either<Failure, PickupDropoffEntity>> userAddress({
    required String taskId,
  });
  Future<Either<Failure, AcceptBidEntity>> acceptBid({required String bidId});

  Future<Either<Failure, BidRejectEntity>> bidReject({required String bidId});

  Future<Either<Failure, StartTaskEntity>> startTask({
    required StartTaskModel startTask,
  });

  Future<Either<Failure, MarkAsCompletedEntity>> markAsCompleted({
    required MarkAsCompletedModel markAsCompleted,
  });
  Future<Either<Failure, WalletSummaryEntity>> getWalletSummary(
      {required WalletSummaryModel model});

  Future<Either<Failure, TaskMessageEntity>> sendtaskAssignmentMessage({
    required String taskAssignmentID,
    required String content,
    required String messageType,
  });
  Future<Either<Failure, List<TaskMessageEntity>>> gettaskAssignmentMessages({
    required String taskAssignmentID,
  });
}
