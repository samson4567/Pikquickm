// refresh_token_model.dart
import 'package:pikquick/features/authentication/domain/entities/Refresh_entiy.dart';

class RefreshTokenModel extends RefreshTokenEntity {
  const RefreshTokenModel({required super.refreshToken});

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      refreshToken: json['refresh_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
    };
  }
}
