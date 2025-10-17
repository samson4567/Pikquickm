import 'package:equatable/equatable.dart';

class ClientEditEmailProfileEntity extends Equatable {
  final String? email;

  const ClientEditEmailProfileEntity({this.email});

  @override
  List<Object?> get props => [email];
}
