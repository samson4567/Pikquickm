import 'package:equatable/equatable.dart';

class ClientEditnameProfileEntity extends Equatable {
  final String? name;

  const ClientEditnameProfileEntity({this.name});

  @override
  List<Object?> get props => [name];
}
