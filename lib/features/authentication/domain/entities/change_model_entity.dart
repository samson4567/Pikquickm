import 'package:equatable/equatable.dart';

class ChangePasswordEntity extends Equatable {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEntity({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}
