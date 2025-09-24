import 'package:pikquick/core/api/pickquick_network_client.dart'
    show PikquickNetworkClient;
import 'package:pikquick/core/constants/endpoint_constant.dart';
import 'package:pikquick/core/db/app_preference_service.dart'
    show AppPreferenceService;
import 'package:pikquick/features/wallet/data/model/client_notification_model.dart';

import 'package:pikquick/features/wallet/data/model/runner_available_model.dart';
import 'package:pikquick/features/wallet/data/model/walllet_balance_model.dart';

abstract class WalletRomoteDatasources {
  Future<WalletBalanceModel> walletBalance(
      {required WalletBalanceModel walletBalance});
  Future<RunnerAvailableModel> runnerAvailable(
      {required RunnerAvailableModel runnerAvailable});

  Future<List<ClientNotificationModel>> clientnotiification(
      {required ClientNotificationModel clientNotification});
}

class WalletRemoteDatasourcesImpl implements WalletRomoteDatasources {
  WalletRemoteDatasourcesImpl(
      {required this.networkClient, required this.appPreferenceService});
  final AppPreferenceService appPreferenceService;

  final PikquickNetworkClient networkClient;

  @override
  Future<WalletBalanceModel> walletBalance(
      {required WalletBalanceModel walletBalance}) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.walletBalance,
      isAuthHeaderRequired: true,
    );
    return WalletBalanceModel.fromJson(response.data);
  }

  @override
  Future<RunnerAvailableModel> runnerAvailable({
    required RunnerAvailableModel runnerAvailable,
  }) async {
    final response = await networkClient.put(
      returnRawData: true,
      endpoint: EndpointConstant.runnerAvailablefodaytodayTask,
      isAuthHeaderRequired: true,
      data: runnerAvailable.toJson(),
    );

    print('Response data********************: ${response.data}');

    if (response.data['success'] == true) {
      // Optionally add timestamp from response
      return runnerAvailable; // or make a copy with updated timestamp
    } else {
      throw Exception("Runner availability update failed");
    }
  }

  @override
  Future<List<ClientNotificationModel>> clientnotiification({
    required ClientNotificationModel clientNotification,
  }) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.clientNotification,
      isAuthHeaderRequired: true,
    );
    // Check if the response contains a 'data' field that holds the list
    final rawData = response.data;
    final List<dynamic> dataList;
    if (rawData is List) {
      // API directly returns a JSON array
      dataList = rawData;
    } else if (rawData is Map<String, dynamic> && rawData['data'] is List) {
      // API returns a JSON object with 'data' key
      dataList = rawData['data'];
    } else {
      throw Exception('Unexpected notifications response format: $rawData');
    }
    return dataList
        .map((item) => ClientNotificationModel.fromJson(item))
        .toList();
  }
}
