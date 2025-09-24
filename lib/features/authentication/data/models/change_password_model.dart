import 'package:pikquick/features/authentication/domain/entities/change_model_entity.dart';

class ChangePasswordModel extends ChangePasswordEntity {
  const ChangePasswordModel({
    required super.currentPassword,
    required super.newPassword,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      currentPassword: json['currentPassword'] ?? '',
      newPassword: json['newPassword'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}
