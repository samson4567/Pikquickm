import 'package:dio/dio.dart';

import 'dart:developer';

import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/core/security/secure_key.dart';
import 'package:pikquick/features/authentication/data/models/token_model.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor({
    required this.appPreferenceService,
    required this.dio,
  });

  final AppPreferenceService appPreferenceService;
  final Dio dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isAuthHeaderRequired = options.extra['isAuthHeaderRequired'] ?? false;
    if (isAuthHeaderRequired) {
      final tokenModel =
          appPreferenceService.getValue<String>(SecureKey.loginAuthTokenKey);
      if (tokenModel != null) {
        final result = TokenModel.deserialize(tokenModel);
        options.headers['Authorization'] = 'Bearer ${result.accessToken}';
      }
    }
    options.extra.clear();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("RESPONSE ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("ERROR ${err.message}");
    super.onError(err, handler);
  }
}
