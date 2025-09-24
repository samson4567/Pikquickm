// bid_reject_model.dart
import 'package:pikquick/features/task/domain/entitties/reject_bid_entity.dart';

class BidRejectModel extends BidRejectEntity {
  const BidRejectModel({
    required super.bidId,
  });

  factory BidRejectModel.fromJson(Map<String, dynamic> json) {
    return BidRejectModel(
      bidId: json['bid_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bid_id': bidId,
    };
  }
}
