import 'package:pikquick/features/task/domain/entitties/bid_offer_entity.dart';

class InitialBidOfferModel extends InitialBidOfferEntity {
  const InitialBidOfferModel({
    required super.taskId,
    required super.amount,
  });

  factory InitialBidOfferModel.fromJson(Map<String, dynamic> json) {
    return InitialBidOfferModel(
      taskId: json['task_id'] as String,
      amount: json['amount'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'amount': amount,
    };
  }
}
