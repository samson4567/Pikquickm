// domain/entities/wallet_summary_entity.dart
import 'package:equatable/equatable.dart';

class WalletSummaryEntity extends Equatable {
  final int? totalEarningsAllTime;
  final int? withdrawableBalance;
  final int? pendingPayments;
  final int? completedTasks;
  final int? totalTasks;
  final int? averageEarningsPerTask;
  final int? thisMonthEarnings;
  final int? lastMonthEarnings;
  final EarningsBreakdownEntity? earningsBreakdown;
  final List<dynamic>?
      recentTransactions; // update later if transaction entity exists

  const WalletSummaryEntity({
    this.totalEarningsAllTime,
    this.withdrawableBalance,
    this.pendingPayments,
    this.completedTasks,
    this.totalTasks,
    this.averageEarningsPerTask,
    this.thisMonthEarnings,
    this.lastMonthEarnings,
    this.earningsBreakdown,
    this.recentTransactions,
  });

  @override
  List<Object?> get props => [
        totalEarningsAllTime,
        withdrawableBalance,
        pendingPayments,
        completedTasks,
        totalTasks,
        averageEarningsPerTask,
        thisMonthEarnings,
        lastMonthEarnings,
        earningsBreakdown,
        recentTransactions,
      ];
}

class EarningsBreakdownEntity extends Equatable {
  final int? taskPayments;
  final int? bonuses;
  final int? adjustments;
  final int? refunds;

  const EarningsBreakdownEntity({
    this.taskPayments,
    this.bonuses,
    this.adjustments,
    this.refunds,
  });

  @override
  List<Object?> get props => [taskPayments, bonuses, adjustments, refunds];
}
