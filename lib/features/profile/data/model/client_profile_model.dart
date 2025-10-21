import 'package:pikquick/features/profile/domain/entities/client_profile_entity.dart';

class ClientEditProfileModel extends ClientEditProfileEntity {
  const ClientEditProfileModel({super.phone});

  factory ClientEditProfileModel.fromJson(Map<String, dynamic> json) {
    return ClientEditProfileModel(phone: json['phone'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'phone': phone};
  }
}
