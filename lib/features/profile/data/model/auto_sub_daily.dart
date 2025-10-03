import 'package:pikquick/features/profile/domain/entities/auto_deduct_entities.dart';

class SubscribeAutoDeductionModel extends SubscribeAutoDeductionEntity {
  const SubscribeAutoDeductionModel({required super.subscribe});

  factory SubscribeAutoDeductionModel.fromJson(Map<String, dynamic> json) {
    return SubscribeAutoDeductionModel(
      subscribe: json['subscribe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscribe': subscribe,
    };
  }

  factory SubscribeAutoDeductionModel.fromEntity(
      SubscribeAutoDeductionEntity entity) {
    return SubscribeAutoDeductionModel(subscribe: entity.subscribe);
  }
}
