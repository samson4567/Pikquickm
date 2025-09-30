import 'package:equatable/equatable.dart';
import 'package:pikquick/features/transaction/data/model/client_review.dart';
import 'package:pikquick/features/transaction/data/model/runner_review_model.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransactionHistoryEvent extends TransactionEvent {
  final String page;
  final String limit;

  const TransactionHistoryEvent({
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [page, limit];
}

// BidHistoryEvent
class GetBidHistoryOfATaskEvent extends TransactionEvent {
  final String taskId;

  const GetBidHistoryOfATaskEvent({required this.taskId});

  @override
  List<Object> get props => [
        taskId,
      ];
}

// client Review

class ClientReviewEvent extends TransactionEvent {
  final ClientReviewModel makeReview;

  const ClientReviewEvent({required this.makeReview});

  @override
  List<Object> get props => [
        makeReview,
      ];
}

//runnerReview
class RunnerReviewEvent extends TransactionEvent {
  final RunnerReviewModel runnerMakeReview;

  const RunnerReviewEvent({required this.runnerMakeReview});

  @override
  List<Object> get props => [
        runnerMakeReview,
      ];
}
