import 'package:pikquick/features/authentication/domain/entities/verifyotp_reset_model.dart';

class ResetOtpVerifyModel extends ResetOtpVerifyEntity {
  const ResetOtpVerifyModel({
    required super.email,
    required super.otp,
  });

  factory ResetOtpVerifyModel.fromJson(Map<String, dynamic> json) {
    return ResetOtpVerifyModel(
      email: json['email'] as String,
      otp: json['otp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}
