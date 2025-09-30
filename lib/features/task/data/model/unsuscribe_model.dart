import 'package:pikquick/features/task/domain/entitties/unsuscribe_entities.dart';

class UnsubscribeAutoDeductionModel extends UnsubscribeAutoDeductionEntity {
  const UnsubscribeAutoDeductionModel({
    required super.unsubscribe,
    super.message = "",
  });

  factory UnsubscribeAutoDeductionModel.fromJson(Map<String, dynamic> json) {
    return UnsubscribeAutoDeductionModel(
      unsubscribe: !(json["subscribe"] ?? true), // backend sends "subscribe"
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "subscribe": false,
    };
  }

  factory UnsubscribeAutoDeductionModel.fromEntity(
    UnsubscribeAutoDeductionEntity entity,
  ) {
    return UnsubscribeAutoDeductionModel(
      unsubscribe: entity.unsubscribe,
      message: entity.message,
    );
  }
}
