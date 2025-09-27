import 'package:equatable/equatable.dart';

class ProfileUploadEntity extends Equatable {
  final String message;

  const ProfileUploadEntity({required this.message});

  @override
  List<Object?> get props => [message];
}
