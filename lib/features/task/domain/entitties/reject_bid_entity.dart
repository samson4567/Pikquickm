// bid_reject_entity.dart
import 'package:equatable/equatable.dart';

class BidRejectEntity extends Equatable {
  final String? bidId;

  const BidRejectEntity({
    required this.bidId,
  });

  @override
  List<Object?> get props => [bidId];
}
