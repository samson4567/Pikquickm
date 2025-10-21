import 'package:pikquick/features/profile/domain/entities/client_profile_entity.dart';
import 'package:pikquick/features/profile/domain/entities/client_profile_name_enity.dart';

class ClientEditProfilenameModel extends ClientEditnameProfileEntity {
  const ClientEditProfilenameModel({
    super.name,
  });

  factory ClientEditProfilenameModel.fromJson(Map<String, dynamic> json) {
    return ClientEditProfilenameModel(name: json['full_name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'full_name': name};
  }
}
