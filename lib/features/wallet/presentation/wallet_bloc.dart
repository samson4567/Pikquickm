import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/features/wallet/domain/repositories/walle_repo.dart';
import 'package:pikquick/features/wallet/presentation/wallet_event.dart';
import 'package:pikquick/features/wallet/presentation/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;

  WalletBloc({required this.walletRepository})
      : super(const WalletBalanceIntial()) {
    on<WalletBalanceEvent>(_onWalletBalance);
    on<RunnerAvailabeEvent>(_onRunnerAvailabe);
    on<GetClientNotificationEvent>(_onGetClientNotificationn);
    on<SendChatMessageEvent>(_onChatSupport);
  }

  Future<void> _onWalletBalance(
    WalletBalanceEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletBalanceLoadingState());

    final result = await walletRepository.walletBalance(
        walletBalance: event.walletBalance);

    result.fold(
      (error) {
        print('[WalletBloc] Error: ${error.message}');
        emit(WalletBalanceErrorState(errorMessage: error.message));
      },
      (balance) {
        print('[WalletBloc] Success: ${balance.balance}');
        emit(WalletBalanceSuccessState(balance: balance));
      },
    );
  }

  Future<void> _onRunnerAvailabe(
    RunnerAvailabeEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const RunnerAvailableLoadingState());

    final result = await walletRepository.runnerAvailabel(
        runnerAvailabl: event.runnerAvailable);

    result.fold(
      (error) {
        emit(RunnerAvailablErrorState(errorMessage: error.message));
      },
      (available) {
        emit(RunnerAvailableSuccessState(available: available));
      },
    );
  }

  Future<void> _onGetClientNotificationn(
      GetClientNotificationEvent event, Emitter<WalletState> emit) async {
    emit(GetClientNotificationLoadingState());
    final result = await walletRepository.clientNotiifcation(
        clientNotiifcation: event.clientnote);
    result.fold(
      (error) =>
          emit(GetClientNotificationErrorState(errorMessage: error.message)),
      (data) =>
          emit(GetClientNotificationsSucessState(clientNotification: data)),
    );
  }

  Future<void> _onChatSupport(
    SendChatMessageEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(ChatSupportLoading());

    final result = await walletRepository.chatSupport(chat: event.chat);
    result.fold(
      (error) => emit(ChatSupportError(message: error.message)),
      (data) => emit(ChatSupportSuccess(chat: data)),
    );
  }
}
