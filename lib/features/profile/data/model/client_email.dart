import 'dart:math';

import 'package:pikquick/features/profile/domain/entities/client_email_entity.dart';
import 'package:pikquick/features/profile/domain/entities/client_profile_entity.dart';
import 'package:pikquick/features/profile/domain/entities/client_profile_name_enity.dart';

class ClientEditProfileEmailModel extends ClientEditEmailProfileEntity {
  const ClientEditProfileEmailModel({
    super.email,
  });

  factory ClientEditProfileEmailModel.fromJson(Map<String, dynamic> json) {
    return ClientEditProfileEmailModel(email: json['email'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
