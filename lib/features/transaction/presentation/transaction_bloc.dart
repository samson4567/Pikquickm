import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/features/transaction/domain/repositories/transaction_repo.dart';
import 'package:pikquick/features/transaction/presentation/transaction_event.dart';
import 'package:pikquick/features/transaction/presentation/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository})
      : super(const TransactionHistoryInitial()) {
    on<TransactionHistoryEvent>(_onTransactionHistory);
    on<BidHistroyEvent>(_onBiidHistoryEvent);
    on<ClientReviewEvent>(_onReviewByClientEvent);
    on<RunnerReviewEvent>(_onReviewByRunnerEvent);
  }

  Future<void> _onTransactionHistory(
    TransactionHistoryEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionHistoryLoadingState());

    final result = await transactionRepository.transactionHistory(
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (error) =>
          emit(TransactionHistoryErrorState(errorMessage: error.message)),
      (transactions) => emit(
        TransactionHistorySuccessState(transactionHistory: transactions),
      ),
    );
  }

  Future<void> _onBiidHistoryEvent(
      BidHistroyEvent event, Emitter<TransactionState> emit) async {
    emit(BidaHistoryLoadingState());
    final result = await transactionRepository.bidsHistory(
      taskId: event.taskId,
    );
    result.fold(
      (error) => emit(BidHistoryErrorState(message: error.message)),
      (message) => emit(BidaHistorySuccessState(message: message)),
    );
  }

  Future<void> _onReviewByClientEvent(
      ClientReviewEvent event, Emitter<TransactionState> emit) async {
    emit(ClientReviewInitalLoadingState());
    final result = await transactionRepository.reviewByClient(
      makeReview: event.makeReview,
    );
    result.fold(
      (error) => emit(ClientReviewErrorState(errorMessage: error.message)),
      (message) => emit(ClientReviewSuccessState(clientReview: message)),
    );
  }

  Future<void> _onReviewByRunnerEvent(
      RunnerReviewEvent event, Emitter<TransactionState> emit) async {
    emit(RunnerReviewInitalLoadingState());
    final result = await transactionRepository.reviewByRunner(
      makeReviewRunner: event.runnerMakeReview,
    );
    result.fold(
      (error) => emit(RiunnerReviewErrorState(errorMessage: error.message)),
      (message) => emit(RunnerReviewSuccessState(runnerReview: message)),
    );
  }
}



//reviewByClient