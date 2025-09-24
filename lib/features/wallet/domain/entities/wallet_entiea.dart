import 'package:equatable/equatable.dart';

class WalletBalanceEntity extends Equatable {
  final double balance;
  const WalletBalanceEntity({required this.balance});
  @override
  List<Object> get props => [balance];
}
