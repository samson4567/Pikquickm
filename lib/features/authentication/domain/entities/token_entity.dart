class TokenEntity {
  TokenEntity({
    required this.accessToken,
    this.refreshToken,
  });
  final String accessToken;
  final String? refreshToken;
}
