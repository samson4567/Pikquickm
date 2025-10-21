import 'package:equatable/equatable.dart';
import 'package:pikquick/features/chat/domain/entities/chat_support_entities.dart';
import 'package:pikquick/features/wallet/domain/entities/client_notification.enity.dart';
import 'package:pikquick/features/wallet/domain/entities/runner_model_entity.dart';
import 'package:pikquick/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pikquick/features/wallet/domain/entities/wallet_entiea.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

final class WalletBalanceIntial extends WalletState {
  const WalletBalanceIntial();
}

class WalletBalanceInitial extends WalletState {}

class WalletBalanceLoadingState extends WalletState {
  const WalletBalanceLoadingState();
}

class WalletBalanceSuccessState extends WalletState {
  final WalletBalanceEntity balance;

  const WalletBalanceSuccessState({required this.balance});

  @override
  List<Object> get props => [balance];
}

class WalletBalanceErrorState extends WalletState {
  final String errorMessage;

  const WalletBalanceErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// runnerAvailableeveryday
final class RunnerAvailableIntial extends WalletState {
  const RunnerAvailableIntial();
}

class RunnerAvailableLoadingState extends WalletState {
  const RunnerAvailableLoadingState();
}

class RunnerAvailableSuccessState extends WalletState {
  final RunnerAvailableEntity available;

  const RunnerAvailableSuccessState({required this.available});

  @override
  List<Object> get props => [available];
}

class RunnerAvailablErrorState extends WalletState {
  final String errorMessage;

  const RunnerAvailablErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//ClientNotification

final class GetClientNotificationInital extends WalletState {
  const GetClientNotificationInital();
}

final class GetClientNotificationLoadingState extends WalletState {}

final class GetClientNotificationsSucessState extends WalletState {
  final List<ClientNotificationEntity> clientNotification;
  const GetClientNotificationsSucessState({required this.clientNotification});
  @override
  List<Object> get props => [clientNotification];
}

final class GetClientNotificationErrorState extends WalletState {
  const GetClientNotificationErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// chatSupport

class ChatSupportInitial extends WalletState {}

class ChatSupportLoading extends WalletState {}

class ChatSupportSuccess extends WalletState {
  final ChatSupportEntity chat;

  const ChatSupportSuccess({required this.chat});

  @override
  List<Object> get props => [chat];
}

class ChatSupportError extends WalletState {
  final String message;

  const ChatSupportError({required this.message});

  @override
  List<Object> get props => [message];
}
