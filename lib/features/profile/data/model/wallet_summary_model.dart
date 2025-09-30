// data/models/wallet_summary_model.dart
import 'package:pikquick/features/profile/domain/entities/wallet_entities.dart';

class WalletSummaryModel extends WalletSummaryEntity {
  const WalletSummaryModel({
    required super.totalEarningsAllTime,
    required super.withdrawableBalance,
    required super.pendingPayments,
    required super.completedTasks,
    required super.totalTasks,
    required super.averageEarningsPerTask,
    required super.thisMonthEarnings,
    required super.lastMonthEarnings,
    required super.earningsBreakdown,
    required super.recentTransactions,
  });

  factory WalletSummaryModel.fromJson(Map<String, dynamic> json) {
    return WalletSummaryModel(
      totalEarningsAllTime: json['totalEarningsAllTime'] ?? 0,
      withdrawableBalance: json['withdrawableBalance'] ?? 0,
      pendingPayments: json['pendingPayments'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
      totalTasks: json['totalTasks'] ?? 0,
      averageEarningsPerTask: json['averageEarningsPerTask'] ?? 0,
      thisMonthEarnings: json['thisMonthEarnings'] ?? 0,
      lastMonthEarnings: json['lastMonthEarnings'] ?? 0,
      earningsBreakdown: EarningsBreakdownModel.fromJson(
        json['earningsBreakdown'] ?? {},
      ),
      recentTransactions: json['recentTransactions'] ?? [],
    );
  }
}

class EarningsBreakdownModel extends EarningsBreakdownEntity {
  const EarningsBreakdownModel({
    required super.taskPayments,
    required super.bonuses,
    required super.adjustments,
    required super.refunds,
  });

  factory EarningsBreakdownModel.fromJson(Map<String, dynamic> json) {
    return EarningsBreakdownModel(
      taskPayments: json['taskPayments'] ?? 0,
      bonuses: json['bonuses'] ?? 0,
      adjustments: json['adjustments'] ?? 0,
      refunds: json['refunds'] ?? 0,
    );
  }
}
