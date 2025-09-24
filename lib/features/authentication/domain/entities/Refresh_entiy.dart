// refresh_token_entity.dart
import 'package:equatable/equatable.dart';

class RefreshTokenEntity extends Equatable {
  final String refreshToken;

  const RefreshTokenEntity({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}
