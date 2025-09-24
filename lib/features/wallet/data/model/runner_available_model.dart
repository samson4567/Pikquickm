// runner_available_model.dart

import 'package:pikquick/features/wallet/domain/entities/runner_model_entity.dart';

class RunnerAvailableModel extends RunnerAvailableEntity {
  const RunnerAvailableModel({required super.isAvailable});

  factory RunnerAvailableModel.fromJson(Map<String, dynamic> json) {
    return RunnerAvailableModel(
      isAvailable: json['isAvailable'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
    };
  }
}
