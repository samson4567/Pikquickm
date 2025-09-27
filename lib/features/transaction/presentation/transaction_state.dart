import 'package:equatable/equatable.dart';
import 'package:pikquick/features/transaction/data/model/bid_history_model.dart';
import 'package:pikquick/features/transaction/domain/entities/client_reviews_entity.dart';
import 'package:pikquick/features/transaction/domain/entities/runner_review_enitty.dart';
import 'package:pikquick/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pikquick/features/wallet/domain/entities/summary_wallet_entities.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

//Transactiion Hisory

final class TransactionHistoryInitial extends TransactionState {
  const TransactionHistoryInitial();
}

final class TransactionHistoryLoadingState extends TransactionState {
  const TransactionHistoryLoadingState();
}

final class TransactionHistorySuccessState extends TransactionState {
  final List<TransactionEntity> transactionHistory;

  const TransactionHistorySuccessState({required this.transactionHistory});

  @override
  List<Object> get props => [transactionHistory];
}

final class TransactionHistoryErrorState extends TransactionState {
  String errorMessage;
  TransactionHistoryErrorState({required this.errorMessage});
}

//clientReviw
final class ClientReviewInital extends TransactionState {
  const ClientReviewInital();
}

final class ClientReviewInitalLoadingState extends TransactionState {
  const ClientReviewInitalLoadingState();
}

final class ClientReviewSuccessState extends TransactionState {
  final ClientReviewEntity clientReview;

  const ClientReviewSuccessState({required this.clientReview});
}

final class ClientReviewErrorState extends TransactionState {
  final String errorMessage;

  const ClientReviewErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//runnerRevie
final class RunnerReviewInital extends TransactionState {
  const RunnerReviewInital();
}

final class RunnerReviewInitalLoadingState extends TransactionState {
  const RunnerReviewInitalLoadingState();
}

final class RunnerReviewSuccessState extends TransactionState {
  final RunnerReviewEntity runnerReview;

  const RunnerReviewSuccessState({required this.runnerReview});
}

final class RiunnerReviewErrorState extends TransactionState {
  final String errorMessage;

  const RiunnerReviewErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// BidsHistory

final class GetBidHistoryOfATaskSuccessState extends TransactionState {
  const GetBidHistoryOfATaskSuccessState(
      {required this.bidHistoryModel, required this.taskID});
  final BidHistoryModel bidHistoryModel;
  final String taskID;

  @override
  List<Object> get props => [bidHistoryModel, taskID];
}

final class GetBidHistoryOfATaskLoadingState extends TransactionState {
  const GetBidHistoryOfATaskLoadingState();
  @override
  List<Object> get props => [];
}

final class GetBidHistoryOfATaskErrorState extends TransactionState {
  const GetBidHistoryOfATaskErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

//UserADress
final class UserAdressIniitalState extends TransactionState {
  const UserAdressIniitalState();
  @override
  List<Object> get props => [];
}
