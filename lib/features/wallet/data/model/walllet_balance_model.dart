import 'package:pikquick/features/wallet/domain/entities/wallet_entiea.dart';

class WalletBalanceModel extends WalletBalanceEntity {
  const WalletBalanceModel({required super.balance});

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
        balance: double.tryParse(json['balance']) ?? 0 // Safe cast to double
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'balance': balance,
      }
    };
  }
}
