import 'package:pikquick/features/profile/domain/entities/client_profile_entity.dart';

class ClientEditProfileModel extends ClientEditProfileEntity {
  const ClientEditProfileModel({super.phone});

  /// Convert from JSON
  factory ClientEditProfileModel.fromJson(Map<String, dynamic> json) {
    return ClientEditProfileModel(
      phone: json['phone'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }

  /// Copy method (optional)
  ClientEditProfileModel copyWith({String? phone}) {
    return ClientEditProfileModel(
      phone: phone ?? this.phone,
    );
  }
}
