import 'package:equatable/equatable.dart';

/// ENTITY
class ResetPasswordEntity extends Equatable {
  final String email;
  final String token;
  final String newPassword;

  const ResetPasswordEntity({
    required this.email,
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, token, newPassword];
}
