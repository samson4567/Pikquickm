// accept_bid_model.dart

import 'package:pikquick/features/task/domain/entitties/accet_bid_enity.dart';

class AcceptBidModel extends AcceptBidEntity {
  const AcceptBidModel({
    required super.bidId,
  });

  factory AcceptBidModel.fromJson(Map<String, dynamic> json) {
    return AcceptBidModel(
      bidId: json['bid_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bid_id': bidId,
    };
  }
}
