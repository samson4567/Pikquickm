import 'dart:convert';

import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/core/security/secure_key.dart';
import 'package:pikquick/features/authentication/data/models/token_model.dart';
import 'package:pikquick/features/authentication/data/models/usermodel.dart';

abstract class AuthenticationLocalDatasource {
  Future<void> cacheAuthToken(TokenModel tokenModel);
  Future<TokenModel?> getCachedAuthToken();
  Future<void> clearCachedAuthToken();

  Future<void> cacheUserData(UserModel userModel);
  Future<UserModel?> getCachedUserData();
  Future<void> clearCachedUserData();
  // ✅ New methods for refresh token
  Future<void> cacheRefreshToken(String refreshToken);
  Future<String?> getCachedRefreshToken();
  Future<void> clearCachedRefreshToken();
}

class AuthenticationLocalDatasourceImpl
    implements AuthenticationLocalDatasource {
  AuthenticationLocalDatasourceImpl({required this.appPreferenceService});
  final AppPreferenceService appPreferenceService;

  @override
  Future<void> cacheAuthToken(TokenModel tokenModel) async {
    await appPreferenceService.saveValue(
        SecureKey.loginAuthTokenKey, TokenModel.serialize(tokenModel));
  }

  @override
  Future<void> clearCachedAuthToken() async {
    await appPreferenceService.removeValue(SecureKey.loginAuthTokenKey);
  }

  @override
  Future<TokenModel?> getCachedAuthToken() async {
    final tokenModel =
        appPreferenceService.getValue<String>(SecureKey.loginAuthTokenKey);
    if (tokenModel == null) return null;
    return TokenModel.deserialize(tokenModel);
  }

  @override
  Future<void> cacheUserData(UserModel userModel) async {
    await appPreferenceService.saveValue(
        SecureKey.loginUserDataKey, jsonEncode(userModel.toJson()));
  }

  @override
  Future<void> clearCachedUserData() async {
    await appPreferenceService.removeValue(SecureKey.loginUserDataKey);
  }

  @override
  Future<UserModel?> getCachedUserData() async {
    final userModel =
        appPreferenceService.getValue<String>(SecureKey.loginUserDataKey);
    if (userModel == null) return null;
    return UserModel.fromJson(jsonDecode(userModel));
  }

  @override
  Future<void> cacheRefreshToken(String refreshToken) async {
    await appPreferenceService.saveValue(
        SecureKey.refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    return appPreferenceService.getValue<String>(SecureKey.refreshTokenKey);
  }

  @override
  Future<void> clearCachedRefreshToken() async {
    await appPreferenceService.removeValue(SecureKey.refreshTokenKey);
  }
}
