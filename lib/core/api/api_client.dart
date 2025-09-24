import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pikquick/core/api/header_interceptor.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/core/error/exception.dart';
import 'package:pikquick/core/logger/logger.dart';
import 'package:pikquick/core/network_info/network_info.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class ApiClient<T> {
  final Dio dio;
  final AppPreferenceService appPreferenceService;
  ApiClient({
    required this.dio,
    required this.appPreferenceService,
  }) {
    dio
      ..options.baseUrl = "https://app.pikquick.com"
      ..options.connectTimeout = const Duration(seconds: 120)
      ..options.receiveTimeout = const Duration(seconds: 120)
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      };

    if (kDebugMode) {
      dio.interceptors.addAll([
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          // compact: false,
        )
      ]);
    }

    dio.interceptors.add(HeaderInterceptor(
      appPreferenceService: appPreferenceService,
      dio: dio,
    ));
  }

  Future<T> get(
      {required String endpoint,
      Options? options,
      Map<String, dynamic>? params}) async {
    try {
      // Options o = BaseOptions();
      if (await ConnectivityHelper.hasInternetConnection()) {
        final response =
            await dio.get(endpoint, queryParameters: params, options: options);
        return response.data;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<T> post({
    required String endpoint,
    dynamic data,
    Options? options,
    Map<String, dynamic>? params,
  }) async {
    try {
      // final response = await dio.post(endpoint,
      //     data: data, options: options, queryParameters: params);
      // return response.data;

      if (await ConnectivityHelper.hasInternetConnection()) {
        final response = await dio.post(endpoint,
            data: data, options: options, queryParameters: params);
        return response.data;
      } else {
        throw const NetworkException();
      }
      // try {
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<T> put({
    required String endpoint,
    dynamic data,
    Options? options,
    Map<String, dynamic>? params,
  }) async {
    try {
      if (await ConnectivityHelper.hasInternetConnection()) {
        final response = await dio.put(endpoint,
            data: data, options: options, queryParameters: params);
        return response.data;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<T> patch(
      {required String endpoint,
      dynamic data,
      Options? options,
      Map<String, dynamic>? params}) async {
    try {
      if (await ConnectivityHelper.hasInternetConnection()) {
        final response = await dio.patch(endpoint,
            data: data, options: options, queryParameters: params);
        Logger.log(
            alertType: AlertType.success, message: "${response.statusCode}");
        return response.data;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<T> delete(
      {required String endpoint,
      dynamic data,
      Options? options,
      Map<String, dynamic>? params}) async {
    try {
      if (await ConnectivityHelper.hasInternetConnection()) {
        final response = await dio.delete(endpoint,
            data: data, options: options, queryParameters: params);
        Logger.log(
            alertType: AlertType.success, message: "${response.statusCode}");
        return response.data;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException error) {
    String errorMessage = "Something went wrong";

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        throw const TimeoutException(message: "Request timed out");

      case DioExceptionType.badResponse:
        Logger.log(
            alertType: AlertType.error,
            message: "${error.response?.statusCode}");
        final response = error.response;
        if (response != null) {
          final responseData = response.data;
          final statusCode = response.statusCode;

          if (responseData is Map<String, dynamic>) {
            errorMessage = responseData['message'] ?? errorMessage;
          }

          if (statusCode != null) {
            switch (statusCode) {
              case 401:
                throw UnAuthorizedException(message: errorMessage);
              case 422:
                throw ClientException(message: errorMessage);
              case 404:
              case 400:
                throw BadRequestException(message: errorMessage);
              default:
                if (statusCode >= 500 && statusCode < 600) {
                  throw ServerException(message: errorMessage);
                }
            }
          }

          Logger.log(alertType: AlertType.error, message: "$responseData");
          Logger.log(alertType: AlertType.error, message: errorMessage);
        }

        throw UnknownException(message: errorMessage);

      case DioExceptionType.unknown:
        throw const UnknownException(message: "An unexpected error occurred");

      default:
        throw UnknownException(message: errorMessage);
    }
  }
}
