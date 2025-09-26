import 'package:equatable/equatable.dart';
import 'package:pikquick/features/wallet/data/model/client_notification_model.dart';
import 'package:pikquick/features/wallet/data/model/runner_available_model.dart';
import 'package:pikquick/features/transaction/data/model/transaction_model.dart';
import 'package:pikquick/features/wallet/data/model/summary_wallet_model.dart';
import 'package:pikquick/features/wallet/data/model/walllet_balance_model.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object> get props => [];
}

class WalletBalanceEvent extends WalletEvent {
  final WalletBalanceModel walletBalance;
  const WalletBalanceEvent({required this.walletBalance});
}

class RunnerAvailabeEvent extends WalletEvent {
  final RunnerAvailableModel runnerAvailable;
  const RunnerAvailabeEvent({required this.runnerAvailable});
}

class GetClientNotificationEvent extends WalletEvent {
  final ClientNotificationModel clientnote;
  const GetClientNotificationEvent({required this.clientnote});
}
