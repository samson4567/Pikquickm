import 'package:dartz/dartz.dart';
import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/features/transaction/data/model/bid_history_model.dart';
import 'package:pikquick/features/transaction/data/model/client_review.dart';
import 'package:pikquick/features/transaction/data/model/runner_review_model.dart';
import 'package:pikquick/features/transaction/domain/entities/client_reviews_entity.dart';
import 'package:pikquick/features/transaction/domain/entities/runner_review_enitty.dart';
import 'package:pikquick/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> transactionHistory({
    required String page,
    required String limit,
  });

  // Future<Either<Failure, String>> bidsHistory({
  //   required String taskId,
  // });

  Future<Either<Failure, ClientReviewEntity>> reviewByClient({
    required ClientReviewModel makeReview,
  });

  Future<Either<Failure, RunnerReviewEntity>> reviewByRunner({
    required RunnerReviewModel makeReviewRunner,
  });
  Future<Either<Failure, BidHistoryModel>> getBidHistoryOfATask(
      {required String taskID});
}
