import 'package:equatable/equatable.dart';

class AcceptBidEntity extends Equatable {
  final String bidId;

  const AcceptBidEntity({
    required this.bidId,
  });

  @override
  List<Object?> get props => [bidId];
}
