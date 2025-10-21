import 'package:equatable/equatable.dart';

class ClientEditProfileEntity extends Equatable {
  final String? phone;

  const ClientEditProfileEntity({this.phone});

  @override
  List<Object?> get props => [phone];
}
