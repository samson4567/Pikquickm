import 'package:equatable/equatable.dart';

class ResetOtpVerifyEntity extends Equatable {
  final String email;
  final String otp;

  const ResetOtpVerifyEntity({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}
