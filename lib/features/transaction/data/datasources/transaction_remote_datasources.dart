import 'package:pikquick/core/api/pickquick_network_client.dart';
import 'package:pikquick/core/constants/endpoint_constant.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/features/transaction/data/model/client_review.dart';
import 'package:pikquick/features/transaction/data/model/runner_review_model.dart';
import 'package:pikquick/features/transaction/data/model/transaction_model.dart';

abstract class TransactionRemoteDatasources {
  Future<List<TransactionModel>> transaction({
    required String page,
    required String limit,
  });
  Future<String> bidHistory({
    required String taskId,
  });
  Future<ClientReviewModel> clientReview(
      {required ClientReviewModel clientReview});

  Future<RunnerReviewModel> runnerReview(
      {required RunnerReviewModel runnerReview});
}

class TransactionRemoteDatasourcesImpl implements TransactionRemoteDatasources {
  final AppPreferenceService appPreferenceService;
  final PikquickNetworkClient networkClient;

  TransactionRemoteDatasourcesImpl(
      {required this.appPreferenceService, required this.networkClient});

  @override
  Future<List<TransactionModel>> transaction({
    required String page,
    required String limit,
  }) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.transaction,
      isAuthHeaderRequired: true,
      params: {
        'page': page,
        'limit': limit,
      },
    );

    // Debug: log the exact response so you can check the structure
    print('Transaction API raw response: ${response.data}');

    List<dynamic>? transactionsList;
    if (response.data is Map<String, dynamic>) {
      transactionsList = response.data['transactions']?['data'];
      transactionsList ??= response.data['transaction']?['data'];
    }
    transactionsList ??= [];
    print(transactionsList);

    // Map to TransactionModel list
    return transactionsList
        .map<TransactionModel>((item) => TransactionModel.fromJson(item))
        .toList();
  }

  @override
  Future<String> bidHistory({required String taskId}) async {
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.bidaHisory}/$taskId/bid-history',
      isAuthHeaderRequired: true,
    );
    return response.message;
  }

  @override
  Future<ClientReviewModel> clientReview({
    required ClientReviewModel clientReview,
  }) async {
    // Debug: Print the values before making the API call
    print('Review Data before sending:');
    print('runner_id: ${clientReview.runnerId}');
    print('client_id: ${clientReview.clientId}');
    print('task_id: ${clientReview.taskId}');
    print('rating: ${clientReview.rating}');
    print('review: ${clientReview.review}');
    print('Full JSON: ${clientReview.toJson()}');

    final response = await networkClient.post(
      endpoint: EndpointConstant.addreviewsbyclient,
      isAuthHeaderRequired: true,
      data: clientReview.toJson(),
    );

    return ClientReviewModel.fromJson(response.data);
  }

  @override
  Future<RunnerReviewModel> runnerReview(
      {required RunnerReviewModel runnerReview}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.addreviewsbyrunner,
      isAuthHeaderRequired: true,
      data: runnerReview.toJson(),
    );

    return RunnerReviewModel.fromJson(response.data);
  }
}
