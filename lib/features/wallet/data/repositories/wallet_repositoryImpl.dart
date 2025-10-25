import 'package:dartz/dartz.dart';
import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/core/mapper/failure_mapper.dart';
import 'package:pikquick/features/wallet/data/datasource/wallet_local_datasources.dart';
import 'package:pikquick/features/wallet/data/datasource/wallet_romote_datasources.dart';
import 'package:pikquick/features/wallet/data/model/client_notification_model.dart';
import 'package:pikquick/features/wallet/data/model/runner_available_model.dart';
import 'package:pikquick/features/transaction/data/model/transaction_model.dart';
import 'package:pikquick/features/wallet/data/model/walllet_balance_model.dart'
    show WalletBalanceModel;
import 'package:pikquick/features/wallet/domain/entities/client_notification.enity.dart';
import 'package:pikquick/features/wallet/domain/entities/runner_model_entity.dart';
import 'package:pikquick/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pikquick/features/wallet/domain/entities/wallet_entiea.dart';
import 'package:pikquick/features/wallet/domain/repositories/walle_repo.dart'
    show WalletRepository;

class WalletRepositoryImpl implements WalletRepository {
  final WalletRomoteDatasources walletRemoteDatasource;
  final WalletLocalDatasources walletLocalDatasource;

  WalletRepositoryImpl({
    required this.walletRemoteDatasource,
    required this.walletLocalDatasource,
  });

  @override
  Future<Either<Failure, WalletBalanceEntity>> walletBalance(
      {required WalletBalanceModel walletBalance}) async {
    try {
      final result = await walletRemoteDatasource.walletBalance(
          walletBalance: walletBalance);
      return Right(result); // result is WalletBalanceModel
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RunnerAvailableEntity>> runnerAvailabel(
      {required RunnerAvailableModel runnerAvailabl}) async {
    try {
      final result = await walletRemoteDatasource.runnerAvailable(
          runnerAvailable: runnerAvailabl);
      return Right(result); // result is WalletBalanceModel
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ClientNotificationEntity>>> clientNotiifcation(
      {required ClientNotificationModel clientNotiifcation}) async {
    try {
      final result = await walletRemoteDatasource.clientnotiification(
          clientNotification: clientNotiifcation);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
