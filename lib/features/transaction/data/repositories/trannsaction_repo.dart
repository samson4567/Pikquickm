import 'package:dartz/dartz.dart';
import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/core/mapper/failure_mapper.dart';
import 'package:pikquick/features/transaction/data/datasources/transaction_local_datasources.dart';
import 'package:pikquick/features/transaction/data/datasources/transaction_remote_datasources.dart';
import 'package:pikquick/features/transaction/data/model/client_review.dart';
import 'package:pikquick/features/transaction/data/model/runner_review_model.dart';
import 'package:pikquick/features/transaction/domain/entities/client_reviews_entity.dart';
import 'package:pikquick/features/transaction/domain/entities/runner_review_enitty.dart';
import 'package:pikquick/features/transaction/domain/repositories/transaction_repo.dart';
import 'package:pikquick/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pikquick/features/transaction/presentation/transaction_state.dart';

class TrannsactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasources transactionRemoteDatasources;
  final TransactionLocalDatasources transactionLocalDatasources;

  TrannsactionRepositoryImpl(
      {required this.transactionLocalDatasources,
      required this.transactionRemoteDatasources});

  @override
  Future<Either<Failure, List<TransactionEntity>>> transactionHistory({
    required String page,
    required String limit,
  }) async {
    try {
      final result = await transactionRemoteDatasources.transaction(
          page: page, limit: limit);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> bidsHistory({required String taskId}) async {
    try {
      final result = await transactionRemoteDatasources.bidHistory(
        taskId: taskId,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ClientReviewEntity>> reviewByClient(
      {required ClientReviewModel makeReview}) async {
    try {
      final result = await transactionRemoteDatasources.clientReview(
        clientReview: makeReview,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RunnerReviewEntity>> reviewByRunner(
      {required RunnerReviewModel makeReviewRunner}) async {
    try {
      final result = await transactionRemoteDatasources.runnerReview(
        runnerReview: makeReviewRunner,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
