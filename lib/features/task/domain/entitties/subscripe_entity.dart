import 'package:equatable/equatable.dart';

class SubscribeAutoDeductionEntity extends Equatable {
  final bool subscribe;

  const SubscribeAutoDeductionEntity({required this.subscribe});

  @override
  List<Object?> get props => [subscribe];
}
