import 'package:dartz/dartz.dart';
import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/features/chat/data/model/chat_support.dart';
import 'package:pikquick/features/chat/domain/entities/chat_support_entities.dart';
import 'package:pikquick/features/wallet/data/model/client_notification_model.dart';
import 'package:pikquick/features/wallet/data/model/runner_available_model.dart';
import 'package:pikquick/features/wallet/data/model/walllet_balance_model.dart';
import 'package:pikquick/features/wallet/domain/entities/client_notification.enity.dart';
import 'package:pikquick/features/wallet/domain/entities/runner_model_entity.dart';
import 'package:pikquick/features/wallet/domain/entities/wallet_entiea.dart';

abstract class ChatRepository {
  Future<Either<Failure, WalletBalanceEntity>> walletBalance(
      {required WalletBalanceModel walletBalance});
  Future<Either<Failure, RunnerAvailableEntity>> runnerAvailabel(
      {required RunnerAvailableModel runnerAvailabl});

  Future<Either<Failure, List<ClientNotificationEntity>>> clientNotiifcation(
      {required ClientNotificationModel clientNotiifcation});
}

//transactionHistory
