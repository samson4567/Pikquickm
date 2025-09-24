import 'package:equatable/equatable.dart';

class NewUserRequestEntity extends Equatable {
  final String? fullName;
  final String? phone;
  final String? email;
  final String? password;
  final String? role;

  const NewUserRequestEntity({
    this.fullName,
    this.phone,
    this.email,
    this.password,
    this.role,
  });

  @override
  List<Object?> get props => [fullName, phone, email, password, role];
}
