import 'package:pikquick/features/authentication/domain/entities/resend_otp.dart';

class ResendOtpModel extends ResendOtpEntity {
  const ResendOtpModel({
    required super.email,

  });

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpModel(
      email: json['email'],
   
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
     
    };
  }
}