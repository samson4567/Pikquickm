import 'package:pikquick/features/authentication/domain/entities/new_user_request_entity.dart';

class NewUserRequestModel extends NewUserRequestEntity {
  const NewUserRequestModel({
    super.fullName,
    super.phone,
    super.email,
    super.password,
    super.role,
  });

  factory NewUserRequestModel.fromJson(Map<String, dynamic> json) {
    return NewUserRequestModel(
      fullName: json['full_name'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
