import 'package:dio/dio.dart';
import 'package:pikquick/core/api/api_client.dart';
import 'package:pikquick/core/api/base_response.dart';

class PikquickNetworkClient extends ApiClient {
  PikquickNetworkClient({
    required super.dio,
    required super.appPreferenceService,
  });

  @override
  Future<BaseResponse> get({
    required String endpoint,
    Options? options,
    Map<String, dynamic>? params,
    bool isAuthHeaderRequired = false,
    bool returnRawData = false,
  }) async {
    final requestOptions = options ?? Options();

    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    final response = await super.get(
      endpoint: endpoint,
      options: requestOptions,
      params: params,
    );
    BaseResponse baseResponse = BaseResponse.fromJson({});
    if (returnRawData) {
      baseResponse.data = response;
    } else {
      baseResponse = BaseResponse.fromJson(response);
    }

    return baseResponse;
  }

  @override
  Future<BaseResponse> post({
    required String endpoint,
    data,
    Options? options,
    Map<String, dynamic>? params,
    bool isAuthHeaderRequired = false,
    bool returnRawData = false,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    final response = await super.post(
      endpoint: endpoint,
      data: data,
      options: requestOptions,
      params: params,
    );
    print("fresh>>$response");
    Map<String, dynamic> rapResponse = {};
    if (response is Map && response['data'] == null) {
      rapResponse = {'status': true, 'messagee': 'success', 'data': response};
      return BaseResponse.fromJson(rapResponse);
    }

    return BaseResponse.fromJson(response);
  }

  @override
  Future<BaseResponse> put({
    required String endpoint,
    data,
    Options? options,
    Map<String, dynamic>? params,
    bool isAuthHeaderRequired = false,
    bool returnRawData = false,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    final response = await super.put(
        endpoint: endpoint,
        data: data,
        options: requestOptions,
        params: params);
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (returnRawData) {
      baseResponse.data = response;
    }

    return baseResponse;
  }

  @override
  Future<BaseResponse> patch({
    required String endpoint,
    data,
    Options? options,
    Map<String, dynamic>? params,
    bool isAuthHeaderRequired = false,
    bool returnRawData = false,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    final response = await super.patch(
        endpoint: endpoint,
        data: data,
        options: requestOptions,
        params: params);
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (returnRawData) {
      baseResponse.data = response;
    }

    return baseResponse;
  }

  @override
  Future<BaseResponse> delete({
    required String endpoint,
    data,
    Options? options,
    Map<String, dynamic>? params,
    bool isAuthHeaderRequired = false,
    bool returnRawData = false,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    final response = await super.delete(
        endpoint: endpoint,
        data: data,
        options: requestOptions,
        params: params);
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (returnRawData) {
      baseResponse.data = response;
    }

    return baseResponse;
  }
}
